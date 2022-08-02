function varargout=xregdesigneditor(varargin)
%XREGDESIGNEDITOR Create/alter design editor window
%
%  H= XREGDESIGNEDITOR  creates a design editor window
%  H= XREGDESIGNEDITOR('create','gui','action','value',...)  creates a
%  window and sets properties
%  XREGDESIGNEDITOR(H,'action','value')  sets properties on a current window

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.19.4.6 $  $Date: 2004/04/12 23:34:32 $

if ~nargin
   varargin={'create',[]};
else
   if mbciscom(varargin{1})
      %callback from tree object
      varargin=[{[],'activex'} {varargin}];
   elseif ishandle(varargin{1})
      H=varargin{1};
   else
      H=i_lookforhandle;
   end
   varargin=varargin(2:end);
end

for n=1:2:length(varargin)
   switch lower(varargin{n})
   case 'create'
      H=i_creategui;
      varargout{1}=H;
   case 'activex'
      i_axeventqueue(varargin{n+1}{:});
   case 'unblocktree'
      i_axeventqueue;
   case 'loadtree'
      i_loadtree(H,varargin{n+1});
   case 'savetree'
      varargout{1}=i_savetree(H);
   case 'lockgui'
      i_setguilock(H,varargin{n+1});
   case 'closefcn'
      i_setclosefcn(H,varargin{n+1});
   case 'adddesign'
      i_adddesign(H,varargin{n+1});
   case 'basemodel'
      i_setbasemodel(H,varargin{n+1});
   case 'lockchosen'
      i_lockchosen(H,varargin{n+1});
   case 'currentstage'
      i_setcurrentstage(H,varargin{n+1});
   case 'numberofstages'
      i_setnumstages(H,varargin{n+1});
   case 'getcurrentstage'
      varargout{1}=i_getcurrentstage(H);
   end
end
return





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  i_creategui, i_createmenus, i_createtree, i_createsbar, %
%  i_createviews, i_createinfo, i_createmain               %
%                                                          %
%  Various creation routines                               %
%                                                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function o_____________CREATEFCNS   % dummy function header puts a break in function listing!
function H=i_creategui
% check for existing gui
H=i_lookforhandle;
if ~isempty(H)
   H=handle(H);
   % ensure the window is properly active
   i_wakeup(H);
   return
end

% load in preferences defaults
p=mbcprefs('mbc');
userprefs=getpref(p,'DesignEditor');

ud.Figure=xregfigure('tag','DOEeditor',...
   'visible','off',...
   'renderer','zbuffer',...
   'name','Design Editor',...
   'keypressfcn','figure(gcbf)',...
   'closerequestfcn',@i_sleep,...
   'deletefcn',@i_delfig,...
   'pointer','watch');
ud.Figure.MinimiseResources='on';
xregpersistfigpos(ud.Figure);
xregmoveonscreen(ud.Figure);
figpos = get(ud.Figure,'position');

% Create pointers 
ud.main= xregGui.RunTimePointer;
ud.main.LinkToObject(ud.Figure);
ud.tree= xregGui.RunTimePointer;
ud.tree.LinkToObject(ud.Figure);
ud.sbar= xregGui.RunTimePointer;
ud.sbar.LinkToObject(ud.Figure);
ud.info= xregGui.RunTimePointer;
ud.info.LinkToObject(ud.Figure);
ud.view= xregGui.RunTimePointer;
ud.view.LinkToObject(ud.Figure);
ud.menus= xregGui.RunTimePointer;
ud.menus.LinkToObject(ud.Figure);

% Create core data structure
i_createmain(ud);

% Create status bar
i_createsbar(ud);

% Create tree
i_createtree(ud);

% Create info pane
i_createinfo(ud);

% Create menus/toolbar
i_createmenus(ud);

% Create View area
i_createview(ud);

i_doviewerenables(ud.menus,ud.main);

% bind together GUI elements
figh=ud.Figure;
spl=xregsplitlayout(figh,'packgroup','DOE_EDITOR',...
   'orientation','ud',...
   'top',ud.tree.info.panel,...
   'bottom',ud.info.info.panel,...
   'split',[.7 .3],...
   'dividerstyle','flat',...
   'dividerwidth',4);
spl=xregsplitlayout(figh,'packgroup','DOE_EDITOR',...
   'right',ud.view.info.card,...
   'left',spl,...
   'split',[userprefs.treesize figpos(3)-userprefs.treesize],...
   'minwidth', [30 30], ...
   'dividerstyle','flat',...
   'dividerwidth',4);

lyt=xreggridbaglayout(figh,'packgroup','DOE_EDITOR',...
   'dimension',[2 1],...
   'rowsizes',[-1 20],...
   'gapy',2,...
   'elements',{spl,ud.sbar.info.panel});

tb=ud.menus.info.Toolbar.Layout;
set(ud.menus.info.Toolbar.Layout,'center',lyt);

figh.LayoutManager=tb;
set(tb,'ToolBarDraw','on','packstatus','on');

% make GUI visible
set(figh,'visible','on','userdata',ud,'pointer','arrow');
H=figh;
return




function i_createmain(allud)
p=allud.main;

ud.Figure=allud.Figure;    % creating RT pointers requires figure
ud.pcurrent= xregdesgui.designpackage;
ud.pcurrent.connect(xregfigurehook(ud.Figure),'up');
ud.pdesigns= xregGui.RunTimePointer(des_linearmod);
ud.pdesigns.LinkToObject(ud.Figure)
ud.currentind=1;
ud.chosenind=[];
ud.chosenlocked=0;
ud.guilocked=0;
ud.closefcn='';
ud.isclosed=0;
ud.PR=xregGui.PointerRepository;
ud.numstages=1;
ud.currentstage=1;

% listen to changes in current design pointer so I can suck them back into main pointer list
% listen to item changes in current so that the Constraints can be checked etc
ud.currentlist=[ud.pcurrent.addlistener('any',{@i_getdesignchange,p,allud.tree})...
      ud.pcurrent.addlistener('item',{@i_itemchange,p})];

p.info=ud;
return



function i_createmenus(allud)
figh=allud.Figure;
p=allud.menus;
psbar=allud.sbar;
pmain=allud.main;
pview=allud.view;

ud.sbar=psbar;
dp=allud.main.info.pcurrent;
ud.list=dp.addlistener('any',{@i_dodesignmenus,p,dp,pmain,allud.tree});
ud.menustates.lock=1;
ud.menustates.optim=0;
ud.menustates.root=1;
ud.menustates.guilocked=0;
ud.menustates.haspoints=0;    % These are the settings that correspond to the initial enable settings
ud.menustates.onchosen=0;

% Top level menus
flmn=uimenu('parent',figh,'label','&File','callback','figure(gcbf)');
edmn=uimenu('parent',figh,'label','&Edit','callback','figure(gcbf)');
dspmn=uimenu('parent',figh,'label','&View','callback',{@i_CheckForDeleteView,pview,dp,p});
desmn=uimenu('parent',figh,'label','&Design','callback','figure(gcbf)');
tlsmn=uimenu('parent',figh,'label','&Tools','callback','figure(gcbf)');
% add window menu
xregwinlist(double(figh));
% add help menu
mv_helpmenu(figh,{'&Design Editor Help','xreg_designEditor'});   

% File Menu items
ud.File.New= uimenu('parent',flmn,'label','&New Design',...
   'callback',{@i_newdesign,pmain,allud.tree,p},'interruptible','off');
ud.File.Delete= uimenu('parent',flmn,'label','&Delete Design','enable','off',...
   'callback',{@i_removedesign,pmain,allud.tree},'interruptible','off');
ud.File.Rename= uimenu('parent',flmn,'label','&Rename Design','enable','off',...
   'callback',{@i_startrenamedesign,allud.tree},'interruptible','off');
ud.File.Props= uimenu('parent',flmn,'label','Pr&operties','enable','off',...
   'callback',{@i_properties,dp,pmain},'interruptible','off','separator','on');
ud.File.Import= uimenu('parent',flmn,'label','&Import Design...','separator','on',...
   'callback',{@i_import,dp,allud.tree,pmain,psbar},'interruptible','off');
ud.File.Export= uimenu('parent',flmn,'label','&Export Design...','enable','off',...
   'callback',{@i_export,dp,pmain,psbar},'interruptible','off');
ud.File.Merge= uimenu('parent',flmn,'label','&Merge Designs...','interruptible','off',...
   'callback',{@i_mergedesigns,dp,psbar,pmain,allud.tree});
ud.File.ConImport= uimenu('parent',flmn,'label','Import Con&straints...','enable','off',...
   'callback',{@i_importcon,dp,pmain,psbar},'interruptible','off','separator','on');
ud.File.Print= uimenu('parent',flmn,'label','&Print...','enable','off',...
   'accelerator','p',...
   'callback',{@i_print,pview,pmain,psbar,'dialog'},'interruptible','off','separator','on');
uimenu('parent',flmn,'label','&Close','separator','on','accelerator','w',...
   'callback','close(gcbf)','interruptible','off');

% Edit menu items
ud.Edit.Copy= uimenu('parent',edmn,'label','&Copy Current View','accelerator','c',...
   'callback',{@i_copy,pview,pmain,psbar},'interruptible','off','enable','off');
ud.Edit.CopyDesign= uimenu('parent',edmn,'label','Co&py Design Data',...
   'callback',{@i_copydesigndata,pview,pmain,psbar},'interruptible','off','enable','off');
ud.Edit.Clear= uimenu('parent',edmn,'label','C&lear','separator','on','callback',...
   {@i_cleardesign,dp,psbar,pmain},'interruptible','off','enable','off');
ud.Edit.Add= uimenu('parent',edmn,'label','&Add Point...','callback',...
   {@i_addpoints,dp,psbar,pmain},'interruptible','off','enable','off');
ud.Edit.Delete= uimenu('parent',edmn,'label','&Delete Point...','callback',...
   {@i_delpoints,dp,psbar,pmain},'interruptible','off','enable','off');
ud.Edit.Sort= uimenu('parent',edmn,'label','&Sort Points...','callback',...
   {@i_sortpoints,dp,psbar,pmain},'interruptible','off','enable','off');
ud.Edit.Fix= uimenu('parent',edmn,'label','&Fix/Free Points...','callback',...
   {@i_fixpoints,dp,psbar,pmain},'interruptible','off','enable','off');
ud.Edit.Randomize= uimenu('parent',edmn,'label','&Randomize','callback',...
   {@i_randomize,dp,psbar,pmain},'interruptible','off','enable','off');
ud.Edit.Round= uimenu('parent',edmn,'label','Ro&und Factor...','callback',...
   {@i_round,dp,psbar,pmain},'interruptible','off','enable','off');
ud.Edit.Constraints= uimenu('parent',edmn,'label','C&onstraints...','callback',...
   {@i_constraints,dp,psbar,pmain},'interruptible','off',...
   'separator','on','enable','off');
ud.Edit.Model= uimenu('parent',edmn,'label','&Model...','callback',...
   {@i_model,dp,psbar,pmain},'interruptible','off',...
   'separator','on','enable','off');
ud.Edit.Select= uimenu('parent',edmn,'label','Select As &Best','interruptible','off',...
   'callback',{@i_selectdes,allud.tree,pmain},'separator','on','enable','off');

% View menu items
viewers=uimenu('parent',dspmn,'label','&Current View','enable','off','callback',{@i_checkviewer,pview});
viewlist=xregdesgui.viewerlist;
% add viewers
for n=1:length(viewlist.Constructors)
   uimenu('parent',viewers,'label',viewlist.MenuLabels{n},'callback',...
      {@i_changeview,viewlist.Constructors{n},pview,dp,pmain,psbar,p},...
      'interruptible','off');
end
ud.View.Current=viewers;
viewopts=uimenu('parent',dspmn,'label','Viewer &Options',...
   'interruptible','off','enable','off',...
   'callback',{@i_setoptionsmenu,pview,p});
% create pool of options menus
for n=1:5
   ud.View.Options.Menuitems(n)=uimenu('parent',viewopts,...
      'visible','off','callback',{@i_dooptions,pview});
end
ud.View.Options.this=viewopts;
ud.View.ShowPointNumbers = uimenu('parent',dspmn,'label','Display Design Point &Numbers','separator','on',...
   'callback',{@i_switchshowdesnumbers, dp, p,pmain,psbar, 1},'interruptible','off','enable','off');
ud.View.ShowPointCount = uimenu('parent',dspmn,'label','Display Design Point Co&unt',...
   'callback',{@i_switchshowdesnumbers, dp, p,pmain,psbar, 2},'interruptible','off','enable','off');
ud.View.SplitVert= uimenu('parent',dspmn,'label','Split &Vertically',...
   'callback',{@i_splitview,pview,dp,'ud',figh,pmain,psbar},'interruptible','off','separator','on','enable','off');
ud.View.SplitHorz= uimenu('parent',dspmn,'label','Split &Horizontally',...
   'callback',{@i_splitview,pview,dp,'lr',figh,pmain,psbar},'interruptible','off','enable','off');
ud.View.Delete=uimenu('parent',dspmn,'label','&Delete Current View',...
   'callback',{@i_deletecurrentview,pview,pmain,psbar, ud.File.Print},...
   'enable','off','interruptible','off');
ud.View.Expand=uimenu('parent',dspmn,'separator','on','label','&Print to Figure',...
   'callback',{@i_expandtofigure,allud.view,dp,pmain,psbar},'interruptible','off','enable','off');

% Design menu items
ud.Design.Optimal= uimenu('parent',desmn,'label','&Optimal...','callback',...
   {@i_optimaldesign,dp,psbar,pmain},'interruptible','on','enable','off');
ud.Design.Classical= uimenu('parent',desmn,'label','&Classical','callback',{@i_ScanForDesigns,2,dp,pmain,psbar},...
   'userdata',0,'interruptible','off','enable','off');
uimenu('parent',ud.Design.Classical,'label','Design &Browser...','callback',{@i_defineddesign,dp,psbar,pmain,2},...
   'interruptible','off');
ud.Design.SpaceFill= uimenu('parent',desmn,'label','&Space Filling','callback',{@i_ScanForDesigns,1,dp,pmain,psbar},...
   'userdata',0,'interruptible','off','enable','off');
uimenu('parent',ud.Design.SpaceFill,'label','Design &Browser...','callback',{@i_defineddesign,dp,psbar,pmain,1},...
   'interruptible','off');

% Tools menu items
ud.Tools.PEV= uimenu('parent',tlsmn,'label','&PEV Viewer','callback',...
   {@i_startPEV,dp,pview,pmain,psbar},'enable','off','interruptible','off');
ud.Tools.Eval= uimenu('parent',tlsmn,'label','&Evaluate Designs','callback',...
   {@i_evaldesigns,pview,pmain,psbar},'interruptible','off');

% Search for additional tools
ext = xregtools.extensions;
Btools = ext.DesignEditorTools;
if length(Btools)
    Btools(1).Separator = 'on';
    mbccreateaddonmenus(Btools, tlsmn);
end



%%%%%%%%%%%%%%%%%%%%%
% context menu      % - for splitting windows
%%%%%%%%%%%%%%%%%%%%%
uic=uicontextmenu('parent',figh,...
   'callback',{@i_ContextView,pview,dp,p});
ud.Context.this=uic;

viewers=uimenu('parent',uic,'label','Current &View');
% add viewers
for n=1:length(viewlist.Constructors)
   uimenu('parent',viewers,'label',viewlist.MenuLabels{n},'callback',...
      {@i_changeview,viewlist.Constructors{n},pview,dp,pmain,psbar,p},...
      'interruptible','off');
end
ud.Context.Current=viewers;
viewopts=uimenu('parent',uic,'label','Viewer &Options',...
   'interruptible','off');
% create pool of options menus
for n=1:5
   ud.Context.Options.Menuitems(n)=uimenu('parent',viewopts,...
      'visible','off','callback',{@i_dooptions,pview});
end
ud.Context.Options.this=viewopts;
ud.Context.ShowPointNumbers = uimenu('parent',uic,'label','Display Design Point &Numbers','separator','on',...
   'callback',{@i_switchshowdesnumbers, dp, p,pmain,psbar,1},'interruptible','off','enable','off');
ud.Context.ShowPointCount = uimenu('parent',uic,'label','Display Design Point Co&unt',...
   'callback',{@i_switchshowdesnumbers, dp, p,pmain,psbar, 2},'interruptible','off','enable','off');
ud.Context.SplitVert= uimenu('parent',uic,'label','Split &Vertically',...
   'callback',{@i_splitview,pview,dp,'ud',figh,pmain,psbar},'interruptible','off','separator','on');
ud.Context.SplitHorz= uimenu('parent',uic,'label','Split &Horizontally',...
   'callback',{@i_splitview,pview,dp,'lr',figh,pmain,psbar},'interruptible','off');
ud.Context.Delete=uimenu('parent',uic,'label','&Delete Current View',...
   'callback',{@i_deletecurrentview,pview,pmain,psbar, ud.File.Print},...
   'enable','off','interruptible','off');
ud.Context.Expand=uimenu('parent',uic,'separator','on','label','&Print to Figure',...
   'callback',{@i_expandtofigure,allud.view,dp,pmain,psbar},'interruptible','off');


% Tree Context Menu
uic=uicontextmenu('parent',figh,'callback',{@i_TreeContextView,dp,p});
ud.TreeContext.this=uic;
ud.TreeContext.new = uimenu(uic,'label','&New Design',...
   'callback',{@i_newdesign,pmain,allud.tree,p},'interruptible','off');
ud.TreeContext.delete = uimenu(uic,'label','&Delete Design','enable','off',...
   'callback',{@i_removedesign,pmain,allud.tree},'interruptible','off');
ud.TreeContext.rename = uimenu(uic,'label','Rena&me Design','enable','off',...
   'callback',{@i_startrenamedesign,allud.tree},'interruptible','off');
ud.TreeContext.eval = uimenu(uic,'label','&Evaluate Design...','separator','on',...
   'callback',{@i_addtoeval,dp,pview,pmain,psbar},'interruptible','off');
ud.TreeContext.props = uimenu(uic,'label','&Properties...',...
   'callback',{@i_properties,dp,pmain},'interruptible','off',...
   'separator','on');


%%%%%%%%%%%%%%%%%%%%%
% toolbar           %
%%%%%%%%%%%%%%%%%%%%%
tb=xregtoolbarlayout(figh,'packgroup','DOE_EDITOR','toolbardraw','off',...
   'ResourceLocation',xregrespath,'spacerwidth',2);
ud.Toolbar.Layout=tb;
tcol=[0 255 0];
ud.Toolbar.New=xregGui.uipushtool(tb,...
   'clickedcallback',{@i_newdesign,pmain,allud.tree,p},...
   'tooltip','New Design',...
   'interruptible','off',...
   'transparentcolor',tcol,...
   'imageFile','des_new.bmp');
ud.Toolbar.Delete=xregGui.uipushtool(tb,...
   'clickedcallback',{@i_removedesign,pmain,allud.tree},...
   'tooltip','Delete Design',...
   'interruptible','off',...
   'transparentcolor',tcol,...
   'enable','off',...
   'imagefile','delete.bmp');
ud.Toolbar.Print=xregGui.uipushtool(tb,...
   'clickedcallback',{@i_print,pview,pmain,psbar,'quiet'},...
   'tooltip','Print Current View',...
   'interruptible','off',...
   'separator','on',...
   'transparentcolor',tcol,...
   'enable','off',...
   'imagefile','print.bmp');
ud.Toolbar.AddPoint=xregGui.uipushtool(tb,...
   'clickedcallback',{@i_addpoints,dp,psbar,pmain},...
   'tooltip','Add Points...',...
   'interruptible','off',...
   'separator','on',...
   'transparentcolor',tcol,...
   'enable','off',...
   'imagefile','insert.bmp');
ud.Toolbar.DelPoint=xregGui.uipushtool(tb,...
   'clickedcallback',{@i_delpoints,dp,psbar,pmain},...
   'tooltip','Delete Points...',...
   'interruptible','off',...
   'transparentcolor',tcol,...
   'enable','off',...
   'imagefile','remove.bmp');
ud.Toolbar.Sort=xregGui.uipushtool(tb,...
   'clickedcallback',{@i_sortpoints,dp,psbar,pmain},...
   'tooltip','Sort...',...
   'interruptible','off',...
   'transparentcolor',tcol,...
   'enable','off',...
   'imagefile','sortasc.bmp');
ud.Toolbar.Classical=xregGui.uipushtool(tb,...
   'clickedcallback',{@i_defineddesign,dp,psbar,pmain,2},...
   'tooltip','Classical Design',...
   'interruptible','off',...
   'transparentcolor',tcol,...
   'ImageFile','des_classical.bmp',...
   'enable','off',...
   'separator','on');
ud.Toolbar.SpaceFill=xregGui.uipushtool(tb,...
   'clickedcallback',{@i_defineddesign,dp,psbar,pmain,1},...
   'tooltip','Space Filling Design',...
   'interruptible','off',...
   'transparentcolor',tcol,...
   'ImageFile','des_spacefill.bmp',...
   'enable','off');
ud.Toolbar.Optimal=xregGui.uipushtool(tb,...
   'clickedcallback',{@i_optimaldesign,dp,psbar,pmain},...
   'tooltip','Optimal Design',...
   'interruptible','off',...
   'transparentcolor',tcol,...
   'ImageFile','des_optimal.bmp',...
   'enable','off');
ud.Toolbar.SplitVert=xregGui.uipushtool(tb,...
   'clickedcallback',{@i_splitview,pview,dp,'ud',figh,pmain,psbar},...
   'tooltip','Split View Vertically',...
   'interruptible','off',...
   'transparentcolor',tcol,...
   'ImageFile','verticalSplit.bmp',...
   'enable','off', ...
   'separator', 'on');
ud.Toolbar.SplitHorz=xregGui.uipushtool(tb,...
   'clickedcallback',{@i_splitview,pview,dp,'lr',figh,pmain,psbar},...
   'tooltip','Split View Horizontally',...
   'interruptible','off',...
   'transparentcolor',tcol,...
   'ImageFile','horizontalSplit.bmp',...
   'enable','off');
mv_helptoolbutton(tb,'xreg_designEditor');

p.info=ud;
return



function i_createsbar(ud)
figh=ud.Figure;
p=ud.sbar;
thisud.panel = xregGui.statusbar('parent',figh);
thisud.panel.addMessage('Ready');
p.info=thisud;
return



function i_createtree(ud)
figh=ud.Figure;
p=ud.tree;

thisud.sbar=ud.sbar;
% callbacks
cb={'NodeClick',mfilename;...
      'Collapse',mfilename;...
      'AfterLabelEdit',mfilename;...
      'RightClick',mfilename;...
      'KeyUp',mfilename;...
      'MouseMove', 'MotionManager';...
      'MouseDown', mfilename};
tr=xregGui.treeview([1 1 10 10],double(figh),cb);
tr.Parent=double(figh);
% create an imagelist
IL=xregGui.ILmanager;
IL.IL.MaskColor=uint32(255*256);
IL.bmp2ind('des_stack.bmp');  % initialise image list
tr.InsertImagelist(IL.IL);
tr.Indentation = 20;
tr.HideSelection = 0;
tr.Appearance = 0;
tr.BorderStyle = 0;

set(tr,'nodelocked',1,1);  % lock editing of root node name
% add root
ns=tr.Nodes;
rt = ns.Add;
rt.Text = 'Designs';
rt.Key = 'root';
rt.Image = 1;
% handy link to parent figure
rt.Tag = double(figh);
tr.SelectedItem = rt;

tr=actxcontainer(tr);   

thisud.tree=tr;
thisud.nodes=ns;
thisud.root=rt; 
thisud.IL=IL;
thisud.panel=xregpaneltitlelayout(figh,'packgroup','DOE_EDITOR','center',tr,'title','Design Tree');

pmain=ud.main;

p.info=thisud;
return



function i_createinfo(ud)
figh=ud.Figure;
p=ud.info;

thisud.desinfo = xregGui.infoPane('parent', figh, 'SplitPosition', .6);
thisud.panel= xregpaneltitlelayout(figh,'packgroup','DOE_EDITOR','center',thisud.desinfo,'title','Properties');
dp=ud.main.info.pcurrent;
thisud.list=dp.addlistener('any',{@i_infoupdate,p,dp});
p.info=thisud;
return



function i_createview(allud)
figh = allud.Figure;
p = allud.view;

ud.sbar = allud.sbar;
ud.Figure = allud.Figure;

% Create the first listed viewer as the default
viewlist = xregdesgui.viewerlist;
ud.maxrec = viewlist.MaxRecommended;
ud.taken = zeros(size(ud.maxrec));
ud.taken(1) = 1;

v = feval(viewlist.Constructors{1},'parent',figh);
v.DesignPointer = allud.main.info.pcurrent;
ud.viewgroup = xregGui.viewGroup;
first_view = xregGui.viewcontainer('parent', figh, ...
    'visible', 'off', ...
    'uicontextmenu',allud.menus.info.Context.this, ...
    'center', v);
ud.viewgroup.addView(first_view);
ud.currentviewer= v;

% Add a listener to track changes in the current view
Hprint = [handle(allud.menus.info.File.Print); allud.menus.info.Toolbar.Print];
Hcopy = handle(allud.menus.info.Edit.Copy);
ud.currentviewlist = handle.listener(ud.viewgroup, 'SelectedViewChange', ...
    {@i_changecurrentview,p,Hprint,Hcopy});

sc = xregGui.SystemColorsDbl;
ud.noview = xregGui.oblong('parent',figh,'color',sc.CTRL_SHADOW);
lyt = xregpanellayout(figh,'center',ud.noview,'packgroup','DOE_EDITOR','innerborder',[0 0 0 0]);
ud.card = xregcardlayout(figh,'packgroup','DOE_EDITOR','numcards',2);
attach(ud.card, lyt, 1);
attach(ud.card, first_view, 2);
ud.statelist = allud.main.info.pcurrent.addlistener( ...
    'item',{@i_cardswitcher,p,allud.main.info.pcurrent,Hprint,handle(allud.menus.info.Edit.Copy)});

% userdata that every view item has
first_view.Userdata = struct('parent',ud.card,'itemnumber',2);  

ud.PEVcloselist=[];  %PEV tool support
ud.PEVupdater=[];
ud.PEVguiH=[];
ud.evalguiH=[];      % eval tool support
p.info=ud;
return




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                          %
%  ActiveX event handler routine                           %
%                                                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function o___________MISCELLANEOUS
function H=i_lookforhandle
H=findobj(allchild(0),'flat','tag','DOEeditor');
return

function i_axeventqueue(varargin)

% one event at a time
persistent DETREEBUSY
persistent TREEQUEUE

if ~nargin
   % clear queue busy flag
   DETREEBUSY=0;
   TREEQUEUE=[];
   return
end

% queue request
TREEQUEUE=[TREEQUEUE;{varargin}];

% decide whether this thread should execute the queue
if isempty(DETREEBUSY) || DETREEBUSY==0
   % execute queue
   DETREEBUSY=1;
   T=varargin{1};
   fh=T.Parent;
   ud=get(fh,'userdata');
   MM=MotionManager(fh);
   MM.EnableTree = false;
   while length(TREEQUEUE)
      try
         args=TREEQUEUE{1};
         ev=args{2};
         args(2)=[];
         switch ev
         case {13,11}
            args{1}.inactive=-1;
            i_treenodeclick(ud.main,ud.tree,args{2});
            args{1}.inactive=0;
         case 9
            i_treerename(ud.main,args{1:3})
         case 14
            i_treerightclick(ud.menus,args{1:3});
         case 3
            args{1}.Inactive=-1;
            switch double(args{2})
            case 46
               % delete key
               if strcmp(get(ud.menus.info.File.Delete,'enable'),'on')
                  i_removedesign([],[],ud.main,ud.tree)
               end
            case 45
               % insert key
               if strcmp(get(ud.menus.info.File.New,'enable'),'on')
                  i_newdesign([],[],ud.main,ud.tree,ud.menus)
               end
            case 113 
               % F2 - rename on tree
               T.StartLabelEdit;
            end
            args{1}.Inactive=0;
         case 8
            % buttondown: pass through to windowbuttondown
            xregcallback(get(fh,'windowbuttondownfcn'),fh,[]);
         end
         % remove arguments that have been executed
         TREEQUEUE(1)=[];
      catch
         % discard event, reselect current node if possible?
         TREEQUEUE(1)=[];
         args{1}.Inactive=0;
      end
   end
   MM.EnableTree = true;
   DETREEBUSY=0;
end
return




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                          %
%  Functions to handle background visibility when "closed" %
%                                                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function i_wakeup(H,evt)
set(H,'visible','on');
return

function i_sleep(H,evt)
ud=get(H,'userdata');

% shut down any child windows
PEVh=ud.view.info.PEVguiH;
if ishandle(PEVh)
   close(PEVh);
end
Evalh=ud.view.info.evalguiH;
if ishandle(Evalh)
   close(Evalh);
end

mainud=ud.main.info;
xregcallback(mainud.closefcn,H,evt);
mainud.isclosed=1;
ud.main.info=mainud;
set(H,'visible','off');

% switch to null view
i_setcurrentdesign(ud.main,1);

% Clear design data - accomplish this safely by setting a new, empty tree
des=i_getdesign(ud.main,1);
i_loadtree(H,struct('designs',{{des}},'parents',0,'chosen',1));

i_setchosenlocked(ud.main,0);
i_setguilocked(ud.main,0);
i_setnumstages(H,1);
i_setcurrentstage(H,1);
i_clearpointers(ud.main);
i_clearsbar(ud.sbar);
return

function i_delfig(H,evt)
% save position prefs
ud=get(H,'userdata');
% save out any user preferences that may have changed
p=mbcprefs('mbc');
prefs=getpref(p,'DesignEditor');
sz=get(ud.tree.info.tree,'position');
prefs.treesize=sz(3);
setpref(p,'DesignEditor',prefs);

% delete child windows
PEVh=ud.view.info.PEVguiH;
if ishandle(PEVh)
   delete(PEVh);
end
Evalh=ud.view.info.evalguiH;
if ishandle(Evalh)
   delete(Evalh);
end
return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                          %
%  Functions to set mouse pointer                          %
%                                                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function ID=i_setpointer(pmain,tp)
ud=pmain.info;
ID=ud.PR.stackSetPointer(ud.Figure,tp);
return

function i_deletepointer(pmain,ID)
ud=pmain.info;
ud.PR.stackRemovePointer(ud.Figure,ID);
return

function i_clearpointers(pmain)
ud=pmain.info;
ud.PR.stackClearAndReset(ud.Figure);
return




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                          %
%  External interface functions                            %
%                                                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function o_____________EXTERNAL_API
function struc=i_savetree(figh)
% create a cell array of designs with parent information
% returns a structure containing the designs, the parent vector
% and the chosen design index
%
ud=get(figh,'userdata');

ns=ud.tree.info.nodes;
mainud=ud.main.info;

ndesigns=length(mainud.pdesigns);
struc.designs=cell(1,ndesigns);
struc.parents=zeros(1,ndesigns);

% n=1 is the root - has no parent
struc.designs{1}=mainud.pdesigns(1).info;
struc.parents(1)=0;
for n=2:ndesigns
   struc.designs{n}=ResetConstraints(mainud.pdesigns(n).info);
   struc.parents(n)=double(ns.Item(n).Parent.Index);
end

% best model
if isempty(mainud.chosenind)
   struc.chosen=1;
else
   struc.chosen=mainud.chosenind;
end
return


function i_loadtree(figh,struc)
ud=get(figh,'userdata');

pmain= ud.main;
psbar= ud.sbar;
msgID=i_addmessage(psbar,'Loading data...');
ptrID=i_setpointer(pmain,'watch');

% Clear current data and gui
i_cleartree(figh,ud.tree);   % Root item remains
i_cleardata(pmain);

if struc.chosen~=1
   i_setchosen(pmain,struc.chosen);
else
   i_setchosen(pmain,[]);
end

% add root design to data only
i_addtodesignlist(pmain,struc.designs{1});
if length(struc.designs)>1
   for n=2:length(struc.designs)
      des=struc.designs{n};
      if i_getguilocked(pmain)
         des=setlock(des,1);
      else
         if any(n==struc.parents) || (struc.chosen==n)
            des=setlock(des,1);  % design is a parent, or the chosen one
         else
            des=setlock(des,0);   % designs are unlocked by default
         end
      end
      i_addtotree(ud.tree,des,struc.parents(n),(struc.chosen==n));
      i_addtodesignlist(pmain,des);
   end
end

% force selection of root
rt=ud.tree.info.root;
tr=ud.tree.info.tree;
tr.SelectedItem=rt;
i_treenodeclick(pmain,ud.tree,rt,1);
i_setcurrentdesign(ud.main,1);

i_doviewerenables(ud.menus,ud.main);

% Remove message
i_deletemessage(psbar,msgID);
i_deletepointer(pmain,ptrID);
return

function i_setguilock(H,state)
% lock/unlock entire gui
ud=get(H,'userdata');
i_setguilocked(ud.main,state);
% lock/unlock all designs
i_applylocktoalldesigns(ud.main,ud.tree);
% update tree
i_updateallnodes(ud.tree,ud.main);
return

function i_lockchosen(H,state)
ud=get(H,'userdata');
% flag chosen design as being locked
i_setchosenlocked(ud.main,state);
return


function i_setclosefcn(H,fcn)
ud=get(H,'userdata');
mainud=ud.main.info;
mainud.closefcn=fcn;
ud.main.info=mainud;
return

function i_setbasemodel(H,m)
ud=get(H,'userdata');
des=designobj(m);
i_setdesign(ud.main,des,1);
return

function i_adddesign(H,des)
ud=get(H,'userdata');
% get a unique name for the design
des=name(des,i_uniquename(ud.tree,name(des)));
if i_getguilocked(ud.main)
   des=setlock(des,1);
else
   des=setlock(des,0);
end
% add to tree and data
i_addtotree(ud.tree,des,1);
i_addtodesignlist(ud.main,des);
return


function i_setcurrentstage(H,stage)
ud=get(H,'userdata');
mainud=ud.main.info;
mainud.currentstage=stage;
ud.main.info=mainud;
return

function stage= i_getcurrentstage(H)
ud=get(H,'userdata');
mainud=ud.main.info;
stage= mainud.currentstage;
return

function i_setnumstages(H,nstage)
ud=get(H,'userdata');
mainud=ud.main.info;
mainud.numstages=nstage;
ud.main.info=mainud;
return





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                          %
%  Functions to maintain main data integrity and provide   %
%  access to data                                          %
%                                                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function o_________________DATA_API
function i_getdesignchange(src,evt,pmain,ptree)
% get the design from the "current" package object and place it 
% back into the list
ud=pmain.info;
des=ud.pcurrent.getdesign;
if ~isempty(des)
   ud.pdesigns(ud.currentind).info=des;
   pmain.info=ud;
   % update tree icon
   i_updatenode(pmain,ptree,ud.currentind); 
end
return

function [des,ind]=i_getcurrentdesign(pmain)
% return the current design
ud=pmain.info;
ind=ud.currentind;
des=ud.pdesigns(ind).info;
return

function des=i_getdesign(pmain,ind)
ud=pmain.info;
des=ud.pdesigns(ind).info;
return

function i_setdesign(pmain,des,ind)
ud=pmain.info;
if ind==1
   ud.pdesigns(1).info=des; % no updates necessary
else
   if ind<=length(ud.pdesigns)
      ud.pdesigns(ind).info=des;
      if ind==ud.currentind
         ud.pcurrent.setdesign(des,'item');  % full update of gui
      end
   end
end
return

function i_addtodesignlist(pmain,des)
% add a new pointer to a new design
ud=pmain.info;
pnewdes=xregGui.RunTimePointer(des);
pnewdes.LinkToObject(ud.Figure);
if ~isempty(ud.pdesigns)
   ud.pdesigns(end+1)=pnewdes;
else
   ud.pdesigns=pnewdes;
end
pmain.info=ud;
return

function i_removefromdesignlist(pmain,ind)
% remove designs from list
ud=pmain.info;
ud.pdesigns(ind)=[];

if ~isempty(ud.chosenind)
   if any(ind==ud.chosenind)
      % discard chosen index marker
      ud.chosenind=[];
   else
      % look for designs before the chosen one that have been deleted and
      % alter the chosen index accordingly
      ud.chosenind=ud.chosenind- sum(ind<ud.chosenind);
   end
end
pmain.info=ud;
return


function i_itemchange(src,evt,pmain)
% this function is one of the first callbacks fired when the current item changes
ud=pmain.info;
dpackage=ud.pcurrent;
des=dpackage.getdesign;
if ~isempty(des)
   des=updatestores(des);
   % put design back into list and current
   dpackage.setdesign(des);  % a quiet update
   ud.pdesigns(ud.currentind).info=des;
   pmain.info=ud;
end
return

function i_setcurrentdesign(pmain,ind)
ud=pmain.info;
if ind==1
   des=[];
else
   des=ud.pdesigns(ind).info;
end
oldind=ud.currentind;
ud.currentind=ind;
pmain.info=ud;
if ind==1 && oldind==0
   ud.pcurrent.setdesign(des);
else
   % disable the listener which pulls a copy back - not needed here
   ud.currentlist(1).enabled='off';
   ud.pcurrent.setdesign(des,'item');
   ud.currentlist(1).enabled='on';
end
return

function i_cleardata(pmain)
% Clear all design pointers
ud=pmain.info;
delete(ud.pdesigns);
ud.pdesigns=[];
ud.pcurrent.setdesign([]);
ud.currentind=0;
pmain.info=ud;
return

function i_setchosen(pmain,ind)
ud=pmain.info;
ud.chosenind=ind;
pmain.info=ud;
return

function ind=i_getchosen(pmain)
ind=pmain.info.chosenind;
return

function i_setchosenlocked(pmain,ind)
ud=pmain.info;
ud.chosenlocked=ind;
pmain.info=ud;
return

function ind=i_getchosenlocked(pmain)
ind=pmain.info.chosenlocked;
return

function i_setguilocked(pmain,ind)
ud=pmain.info;
ud.guilocked=ind;
pmain.info=ud;
return

function ind=i_getguilocked(pmain)
ind=pmain.info.guilocked;
return

function i_lockcurrentdesign(pmain)
if pmain.info.currentind~=1
   dp=pmain.info.pcurrent;
   des=dp.getdesign;
   if ~getlock(des)
      dp.setdesign(setlock(des,1),'lock');
   end
end
return

function i_unlockcurrentdesign(pmain)
if pmain.info.currentind~=1
   dp=pmain.info.pcurrent;
   des=dp.getdesign;
   if getlock(des)
      dp.setdesign(setlock(des,0),'lock');
   end
end
return

function i_unchoosedesign(pmain,ptree)
ud=pmain.info;
if ~isempty(ud.chosenind)
   ind=ud.chosenind;
   ud.chosenind=[];
   pmain.info=ud;
   if ~ud.guilocked && ~i_isnodeaparent(ptree,ind);
      ud.pdesigns(ind).info=setlock(ud.pdesigns(ind).info,0);
   end
   i_updatenode(pmain,ptree,ind);
end
return

function i_applylocktoalldesigns(pmain,ptree)
% scan each design and apply the correct lock status to it
ud=pmain.info;
Ndes=length(ud.pdesigns);
guilock=ud.guilocked;
if ~isempty(ud.chosenind)
   chind=ud.chosenind;
else
   chind=0;
end
pdes=ud.pdesigns;
if Ndes>1
   for n=2:Ndes
      prnt=i_isnodeaparent(ptree,n);
      if guilock || prnt || n==chind
         pdes(n).info=setlock(pdes(n).info,1);
      else
         pdes(n).info=setlock(pdes(n).info,0);
      end
   end
   % update current design
   if ud.currentind~=1
      ud.pcurrent.setdesign(pdes(ud.currentind).info,'lock');
   else
      ud.pcurrent.setdesign([],'lock');
   end
end
return

function N=i_getnumberofdesigns(pmain)
ud=pmain.info;
N=length(ud.pdesigns)-1;   % remove root from this value
return





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                          %
%  Functions to handle interactions with the list of       %
%  designs and the tree                                    %
%                                                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function o_________________TREE_API
function i_addtotree(ptree,des,prntind,ischosen)
treeud=ptree.info;
if nargin<4
   ischosen=0;
end
if nargin<3
   try
      current_node=get(treeud.tree,'SelectedItem');
      prntind=double(current_node.Index);
   catch
      current_node=treeud.root;
      prntind=1;
   end
else
   current_node = treeud.nodes.Item(prntind);
end

% add a new node
newnode = treeud.nodes.Add(current_node,4,'',name(des),treeud.IL.bmp2ind(iconfile(des,ischosen)));
newnode.Tag=treeud.tree.Parent;
EnsureVisible(newnode);
newind=double(newnode.index);
return



function nmout = i_uniquename(ptree, nmin)
% nmin is the suggested name
% if necessary, nmout will contain the name_X
if nargin<2
   nmin='Design';
end
ud = ptree.info;
% get all names in design tree
nmsused = ud.tree.GetAllNames;
% Check for usage of name
if any(strcmp(nmin, nmsused))
   % loop over _X until an unused one is found
   ok=0;
   n=0;
   while ~ok
      n=n+1;
      % append _X
      nmout = [nmin sprintf('_%d',n)];
      % check newname
      if ~any(strcmp(nmout, nmsused))
         ok=1;
      end
   end
else
   nmout=nmin;
end
return


function i_treenodeclick(pmain,ptree,node,force)
ud=ptree.info;
if nargin<4
   force=0;   % force flag used by internal tree-click generators
end
% make sure we pick up selected design; collapsing fires
% this event but doesn't reselect the node all the time
nd=ud.tree.SelectedItem;

% change current design 
ind=double(nd.Index);
if (ind~=pmain.info.currentind) || (force && (ind~=1))
   ptrID=i_setpointer(pmain,'watch');
   msgID=i_addmessage(ud.sbar,'Updating display...');
   i_setcurrentdesign(pmain,ind);
   i_deletemessage(ud.sbar,msgID);
   i_deletepointer(pmain,ptrID);
end
return


function i_updatenode(pmain,ptree,ind)
% update image and text in node
ud=ptree.info;
if nargin<3
   [des,ind]=i_getcurrentdesign(pmain);
else
   des=i_getdesign(pmain,ind);
end
if ind~=1
   nd = ud.nodes.Item(ind);
   chind=i_getchosen(pmain);
   chosen=0;
   if ~isempty(chind)
      if chind==ind
         chosen=1;
      end
   end
   nd.Image=ud.IL.bmp2ind(iconfile(des,chosen));
   nd.Text=name(des);
end
return

function i_updateallnodes(ptree,pmain)
ud=ptree.info;
Ndes=double(ud.nodes.Count);
if Ndes>1
   nds=ud.nodes;
   chind=i_getchosen(pmain);
   if isempty(chind)
      chind=0;
   end
   IL=ud.IL;
   for n=2:Ndes
      d=i_getdesign(pmain,n);
      nd = nds.Item(n);
      nd.Image=IL.bmp2ind(iconfile(d,n==chind));
   end
end
return

function cnode= i_getcurrenttreenode(ptree)
ud=ptree.info;
try
   cnode=ud.tree.SelectedItem;
catch
   cnode=ud.root;
end
return

function ind= i_getallchildren(nd)
nchld=double(nd.Children);
if nchld
   childnd=nd.Child;
   ind=[];
   for n=1:nchld
      ind=[ind, double(childnd.Index)];
      % recurse into child
      ind=[ind, i_getallchildren(childnd)];
      % goto next child
      if n<nchld
         childnd = childnd.Next;
      end
   end
else
   ind=[];
end
return


function i_deletenode(ptree,nd)
% remove node from tree
nd.key='REMKEY';
ptree.info.nodes.Remove('REMKEY');
return


function out= i_iscurrentaparent(ptree)
ud=ptree.info;
try
   nd=ud.tree.SelectedItem;
catch
   nd=[];
end
if ~isempty(nd)
   out=(nd.Children>0);
else
   out=0;
end
return

function out= i_isnodeaparent(ptree,ind)
ud=ptree.info;
try
   nd = ud.nodes.Item(ind);
catch
   nd=[];
end
if ~isempty(nd)
   out=(nd.Children>0);
else
   out=0;
end
return

function i_treerightclick(pmenus,h,x,y)
ud=pmenus.info;
% show context menu
set(ud.TreeContext.this,'visible','off');drawnow('expose');
xregcallback(get(ud.TreeContext.this,'callback'),ud.TreeContext.this,[]);

objpos=move(h);
x=double(x)+objpos(1);
y=double(y)+objpos(2);

set(ud.TreeContext.this,'position',[x y],'visible','on');
return


function i_treerename(pmain,h,cancelflag,nm)
ud=pmain.info;
nd=h.SelectedItem;
ind=double(nd.Index);
if ind==1
   % root node _should_ be locked.  Don't do anything if we get here
else
   % update name in design object
   des=ud.pcurrent.getdesign;
   des=name(des,nm);
   ud.pcurrent.setdesign(des, 'name');
   ud.pdesigns(ind).info=des;
end


function i_cleartree(figh,ptree)
ud=ptree.info;
ud.nodes.Clear;
% add the root node back in
rt = ud.nodes.Add;
rt.Text='Designs';
rt.Key='root';
rt.Image=1;
% handy link to parent figure
rt.Tag=double(figh);
ud.root=rt;
ud.tree.SelectedItem = rt;
ptree.info=ud;
return


function i_selectnodeontree(ptree,ind)
ud=ptree.info;
nds=ud.tree.Nodes;
if ind<=double(nds.count)
   ud.tree.SelectedItem= nds.Item(ind);
end






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                          %
%  Functions to handle maintaining the view area           %
%                                                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function o_________________VIEW_API
function i_cardswitcher(src,evt,pview,dp,hPrnt,hCpy)
ud=pview.info;
des=dp.getdesign;
if ~isempty(des)
   set(ud.card,'currentcard',2);
   % check for printing support
   if ud.currentviewer.CanPrint
      set(hPrnt,'enable','on');
      set(hCpy,'enable','on');
   else
      set(hPrnt,'enable','off');
      set(hCpy,'enable','off');
   end
else
   set(ud.card,'currentcard',1);
   set([hPrnt;hCpy],'enable','off');  % disable printing
end
return


function i_changeview(src,evt,newclass,pview,dp,pmain,psbar,pmenus)
ud=pview.info;

if ~strcmp(newclass,class(ud.currentviewer))
    % post message to statusbar
    msgID = i_addmessage(psbar,'Changing current viewer...');
    ptrID = i_setpointer(pmain,'watch');

    viewlist = xregdesgui.viewerlist;
    oldind = strmatch(class(ud.currentviewer),viewlist.Constructors);
    newind = strmatch(newclass,viewlist.Constructors);

    % create new object
    newobj = feval(newclass,'parent',ud.Figure,'designpointer',dp);
    delete(ud.currentviewer);
    ud.currentviewer = newobj;
    set(ud.viewgroup.SelectedView,'center',newobj);

    newobj.visible = 'on';
    ud.taken(oldind) = ud.taken(oldind)-1;
    ud.taken(newind) = ud.taken(newind)+1;
    pview.info=ud;

    % enable/disable Print menu
    mnud = pmenus.info;
    if newobj.CanPrint
        set(mnud.File.Print,'enable','on');
        set(mnud.Toolbar.Print,'enable','on');
        set(mnud.Edit.Copy,'enable','on');
    else
        set(mnud.File.Print,'enable','off');
        set(mnud.Toolbar.Print,'enable','off');
        set(mnud.Edit.Copy,'enable','off');
    end

    % Remove message
    i_deletemessage(psbar,msgID);
    i_deletepointer(pmain,ptrID);
end
return



function i_expandtofigure(src,evt,pview,dp,pmain,psbar)
ud=pview.info;
msgID=i_addmessage(psbar,'Copying current viewer to new window...');
ptrID=i_setpointer(pmain,'watch');

des=ud.currentviewer.designpointer.getdesign;
f=xregfigure('visible','off',...
   'name',[gettitle(ud.currentviewer) ' - ' name(des)],...
   'renderer','zbuffer',...
   'menubar','figure',...
   'toolbar','figure',...
   'handlevisibility','on',...
   'color','w');
% add a safety listener to stop annotation from destroying the resize fcn.
p=schema.prop(f,'ResizeSaver','handle');
p=schema.prop(f,'ResizeSaverData','MATLAB callback');
f.ResizeSaver=handle.listener(f,f.findprop('ResizeFcn'),'PropertyPostSet',{@i_expandedfiguresaver,f});
f.ResizeSaverData=f.ResizeFcn;


% send a "printcopy" to the figure if available
if ud.currentviewer.CanPrint
   L= ud.currentviewer.printcopy(f);
   f.LayoutManager=L;
   set(L,'packstatus','on');
else
   dp=xregdesgui.designpackage;
   dp.setdesign(setlock(des,1));
   newviewer=feval(class(ud.currentviewer),'parent',f,'visible','on','designpointer',dp);
   
   frame=xregpanellayout(f,'packstatus','off','innerborder',[0 0 0 0],'center',newviewer);
   f.LayoutManager=frame;
   set(frame,'packstatus','on');
end
set(f,'visible','on');

% Remove message
i_deletemessage(psbar,msgID);
i_deletepointer(pmain,ptrID);
return


function i_expandedfiguresaver(src,evt,Hfig)
if ischar(Hfig.ResizeFcn) && strcmp(Hfig.ResizeFcn,'doresize(gcbf)')
   % restore to my nice resizefcn
   Hfig.ResizeFcn=Hfig.ResizeSaverData;
end


function i_splitview(src,evt,pview,dp,orient,figh,pmain,psbar)
msgID = i_addmessage(psbar,'Splitting current view...');
ptrID = i_setpointer(pmain,'watch');

ud = pview.info;
viewlist = xregdesgui.viewerlist;

allwd = find((ud.taken<ud.maxrec) & (nfactors(dp.getdesign)>=viewlist.MinFactors));
[unused,ind] = min(ud.taken(allwd));
ind = allwd(ind);

currentitemud = ud.viewgroup.SelectedView.UserData;
uic = ud.viewgroup.SelectedView.UIContextMenu;
newview = feval(viewlist.Constructors{ind},'parent',figh,'designpointer',dp);
newcont = xregGui.viewcontainer('parent', figh, ...
    'visible', 'off', ...
    'center', newview, ...
    'uicontextmenu', uic);
ud.viewgroup.addView(newcont);
newsplit= xregsplitlayout(figh,'packgroup','DOE_EDITOR','packstatus','off',...
    'visible','off',...
    'orientation',orient,...
    'dividerstyle','flat','dividerwidth',4,...
    'left',ud.viewgroup.SelectedView,'right',newcont,...
    'userdata',currentitemud);

% set new userdata on items
set(ud.viewgroup.SelectedView,...
    'userdata',struct('parent',newsplit,'itemnumber',1));
set(newcont,...
    'userdata',struct('parent',newsplit,'itemnumber',2));

% replace current viewer with new splitter
replace(currentitemud.parent,newsplit,currentitemud.itemnumber);
set(currentitemud.parent,'packstatus','on');
set(newsplit,'visible','on');

% Increment the count of the number of this view
ud.taken(ind) = ud.taken(ind)+1;
pview.info = ud;
% Remove message
i_deletemessage(psbar,msgID);
i_deletepointer(pmain,ptrID);
return



function i_changecurrentview(src,evt,pview, hPrint, hCopy)
% Track the current viewer
ud = pview.info;
ud.currentviewer = evt.data.NewView.Center;
pview.info=ud;

% Update Copy/Print menu status
if ud.currentviewer.CanPrint
    set([hPrint; hCopy],'enable','on');
else
    set([hPrint; hCopy],'enable','off');
end
return


function i_deletecurrentview(src,evt,pview,pmain,psbar, hPrint)
msgID = i_addmessage(psbar,'Deleting current view...');
ptrID = i_setpointer(pmain,'watch');

ud = pview.info;
currentud = get(ud.viewgroup.SelectedView,'userdata');
parentud = get(currentud.parent,'userdata');
if currentud.itemnumber==1
   otherside = get(currentud.parent,'right');
else
   otherside = get(currentud.parent,'left');
end

% Remove the viewcontainer
viewlist = xregdesgui.viewerlist;
oldind = strmatch(class(ud.currentviewer),viewlist.Constructors);
ud.taken(oldind) = ud.taken(oldind)-1;
pview.info=ud;

% Deleting the view forces a re-selection at the same time
delete(ud.viewgroup.SelectedView);

% Remove the split layout
set(currentud.parent, 'packstatus','off', 'left',[], 'right',[]);
delete(currentud.parent);

% Re-instate the remaining viewcontainer in place of the split
set(otherside, 'userdata', parentud);
replace(parentud.parent, otherside, parentud.itemnumber);
set(parentud.parent, 'packstatus','on');

% Remove message
i_deletemessage(psbar,msgID);
i_deletepointer(pmain,ptrID);
return


function i_startPEV(src,evt,dp,pview,pmain,psbar)
ud=pview.info;
fH=mvf('mvPEVView');
if isempty(fH)
   msgID=i_addmessage(psbar,'Starting Prediction Error Variance tool...');
   ptrID=i_setpointer(pmain,'watch');
   
   des=dp.getdesign;
   if builtin('isempty',des)
      % create a dummy empty design
      des=des_linearmod;
   end
   fH= mv_PEVView('create',des);
   % start a listener to keep viewer updated with current design
   ud.PEVupdater=dp.addlistener('any',{@i_updatePEV,dp,pmain,psbar});
   ud.PEVcloselist=handle.listener(fH,'ObjectBeingDestroyed',{@i_closingPEV,pview});
   ud.PEVguiH=fH;
   pview.info=ud;
   
   % Remove message
   i_deletemessage(psbar,msgID);
   i_deletepointer(pmain,ptrID);
else
   figure(fH);
end
return


function i_updatePEV(src,evt,dp,pmain,psbar)
msgID=i_addmessage(psbar,'Updating Prediction Error Variance tool...');
ptrID=i_setpointer(pmain,'watch');

des=dp.getdesign;
if builtin('isempty',des)
   des=des_linearmod;
end
mv_PEVView('update',mvf('mvPEVView'),[],[],des);
% Remove message
i_deletemessage(psbar,msgID);
i_deletepointer(pmain,ptrID);
return


function i_closingPEV(src,evt,pview)
ud=pview.info;
delete(ud.PEVcloselist);  ud.PEVcloselist=[];
delete(ud.PEVupdater);  ud.PEVupdater=[];
ud.PEVguiH=[];
pview.info=ud;
return


function i_evaldesigns(src,evt,pview,pmain,psbar)
msgID=i_addmessage(psbar,'Opening evaluation tool...');
ptrID=i_setpointer(pmain,'watch');

mainud=pmain.info;
str='Select the designs you want to evaluate by Shift- or Ctrl-clicking on them:';
[des,ok]=mv_designlist(mainud.pdesigns(2:end),str);
if ok && ~isempty(des)
   % create one
   drawnow('expose');
   viewud=pview.info;
   des_eval = cell(1, length(des));
   for n=1:length(des)
      des_eval{n}=des(n).info;
   end
   viewud.evalguiH=mv_doeanalysis('create',des_eval);
   pview.info=viewud;
end

% Remove message
i_deletemessage(psbar,msgID);
i_deletepointer(pmain,ptrID);
return



function i_addtoeval(src,evt,dp,pview,pmain,psbar)
msgID=i_addmessage(psbar,'Adding design to Evaluation Tool...');
ptrID=i_setpointer(pmain,'watch');

des=dp.getdesign;
viewud=pview.info;
if isempty(viewud.evalguiH)
   % create one
   viewud.evalguiH=mv_doeanalysis('create',des);
else
   if ishandle(viewud.evalguiH)
      tg=get(viewud.evalguiH,'tag');
   else
      tg='';
   end
   if strcmp(tg,'DOEtool')
      vis=get(viewud.evalguiH,'visible');
      if strcmp(vis,'on')
         mv_doeanalysis('adddes',viewud.evalguiH,des);
         figure(viewud.evalguiH);
      else
         viewud.evalguiH=mv_doeanalysis('create',des);
      end
   else
      viewud.evalguiH=mv_doeanalysis('create',des);
   end
end
pview.info=viewud;

% Remove message
i_deletemessage(psbar,msgID);
i_deletepointer(pmain,ptrID);
return


function  i_print(src,evt,pview,pmain,psbar,opt)
ud=pview.info;
des=pmain.info.pcurrent.getdesign;

f=figure('visible','off','renderer','zbuffer','units','pixels',...
   'color','w','paperunits','centimeters','paperpositionmode','auto','position',[0 0 100 100]);

% work out the pixels/centimeter
Ppos=get(f,'paperposition');

Xpix_cm=100./Ppos(3);
Ypix_cm=100./Ppos(4);

% make figure big enough for page, minus borders, and center on page
Psz=get(f,'papersize');
xregcenterfigure(f,(Psz-[3 4]).*[Xpix_cm Ypix_cm]);
set(f,'paperposition',[1.5 2 Psz(1)-3 Psz(2)-4]);
Fsz=get(f,'position');
Fsz=Fsz(3:4);

% scale Printobj
Pobj=printcopy(ud.currentviewer,f);

sz=get(ud.currentviewer,'position');
sz=sz(3:4);

% scale width to fit
scale=Fsz(1)./sz(1);
sz=sz.*scale;
% if height is too much, scale down
if sz(2)>(Fsz(2)-50)
   % scale down further
   scale=(Fsz(2)-50)./sz(2);
   sz=sz.*scale;   
end

% position objects
set(Pobj,'position',[(Fsz(1)-sz(1))./2 Fsz(2)-sz(2)-50 sz(1:2)],'visible','on');

titleH = axestext(f,'string',[ud.currentviewer.gettitle ' for "' name(des) '"'],'fontsize',11,'fontweight','bold',......
   'HorizontalAlignment','center','VerticalAlignment','middle','units','pixels',...
   'interpreter','none','position',[1 Fsz(2)-30 Fsz(1) 25]);

if strcmp(opt,'dialog')
   printdlg(f);
elseif strcmp(opt,'quiet')
   print(sprintf('-f%.16f',f));
elseif strcmp(opt,'clipboard')
   print(sprintf('-f%.16f',f),'-dmeta');
end
delete(f);
return


function  i_copy(src,evt,pview,pmain,psbar)
% This is similar to print, but doesn't have to worry about the final paper size
ud=pview.info;
des=pmain.info.pcurrent.getdesign;

if ud.currentviewer.CanPrint
   f=figure('visible','off','renderer','zbuffer','units','pixels',...
      'color','w','paperunits','centimeters','paperpositionmode','auto','position',[0 0 100 100]);
   
   % work out the pixels/centimeter
   Ppos=get(f,'paperposition');
   
   Xpix_cm=100./Ppos(3);
   Ypix_cm=100./Ppos(4);
   
   
   Pobj=printcopy(ud.currentviewer,f);
   
   sz=get(ud.currentviewer,'position');
   sz=sz(3:4);
   
   set(f,'papersize',(sz+[0 50])./[Xpix_cm Ypix_cm],'position',[1 1 sz+[0 50]],'paperposition',[0 0 (sz+[0 50])./[Xpix_cm Ypix_cm]]);
   
   % position objects
   set(Pobj,'position',[1 1 sz],'visible','on');
   
   titleH = axestext(f,'string',[ud.currentviewer.gettitle ' for "' name(des) '"'],'fontsize',11,'fontweight','bold',......
      'HorizontalAlignment','center','VerticalAlignment','middle','units','pixels',...
      'interpreter','none','position',[1 sz(2)+15 sz(1) 25]);
   
   print(sprintf('-f%.16f',f),'-dmeta');
   delete(f);
end
return


function  i_copydesigndata(src,evt,pview,pmain,psbar)
% copy design data to clipboard
des=pmain.info.pcurrent.getdesign;
cb=mbcfoundation.clipboard;
cb.copy(invcode(model(des),factorsettings(des)));


function i_switchshowdesnumbers(src, evt, dp, pmenus, pmain, psbar, setting)
% Turns the display of design point numbers on and off
msgID=i_addmessage(psbar,'Updating display...');
ptrID=i_setpointer(pmain,'watch');

if setting==dp.DesignShowTestNumbers
    % Turn off labels
    dp.DesignShowTestNumbers = 0;
    check = {'off'; 'off'};
else
    dp.DesignShowTestNumbers = setting;
    check = {'off'; 'off'};
    check{setting} = 'on';
end

menusud = pmenus.info;
set([menusud.View.ShowPointNumbers; menusud.View.ShowPointCount; ...
    menusud.Context.ShowPointNumbers; menusud.Context.ShowPointCount], ...
    {'checked'}, [check;check]);

i_deletepointer(pmain,ptrID);
i_deletemessage(psbar,msgID);
return






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                          %
%  Functions to handle maintaining the info pane           %
%                                                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function o_________________INFO_API
function i_infoupdate(src,evt,pinfo,dp);
ud=pinfo.info;
des=dp.getdesign;
if ~isempty(des)
    ud.desinfo.ListText = info(des);
    set(ud.panel,'title',['Properties - ' name(des)]);
else
    ud.desinfo.ListText = {};
    set(ud.panel,'title','Properties');
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                          %
%  Functions to handle maintaining the menu status         %
%                                                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function o_________________MENU_API
function i_dodesignmenus(src,evt,pmenu,dp,pmain,ptree)
ud=pmenu.info;
des=dp.getdesign;

% get new states
if isempty(des)
   root=1;
   optim=0;
   haspoints=0;
   lock=1;
   onchosen=0;
else
   root=0;
   optim=isoptimcapable(des);
   haspoints=npoints(des);
   lock=getlock(des); 
   chind=i_getchosen(pmain);
   onchosen=0;
   if ~isempty(chind)
      [d,ind]=i_getcurrentdesign(pmain);
      if chind==ind
         onchosen=1;
      end
   end
end
guilocked=pmain.info.guilocked;

hndls=[];
enstate={};
if root~=ud.menustates.root
    hndls=[hndls; handle(ud.File.Export); ...
            handle(ud.View.Current); ...
            handle(ud.View.Options.this); ...
            handle(ud.View.SplitVert);...
            handle(ud.View.SplitHorz); ...
            handle(ud.View.Expand); ...
            handle(ud.Tools.PEV); ...
            handle(ud.File.Props); ...
            handle(ud.TreeContext.eval);...
            handle(ud.TreeContext.props); ...
            handle(ud.TreeContext.rename); ...
            handle(ud.File.Rename); ...
            handle(ud.View.ShowPointNumbers); ...
            handle(ud.Context.ShowPointNumbers); ...
            handle(ud.View.ShowPointCount); ...
            handle(ud.Context.ShowPointCount); ...
            ud.Toolbar.SplitVert; ...
            ud.Toolbar.SplitHorz];
    if root
        enstate=[enstate;repmat({'off'},18,1)];
    else
        enstate=[enstate;repmat({'on'},18,1)];
    end
end
if haspoints~=ud.menustates.haspoints
    hndls=[hndls; handle(ud.Edit.CopyDesign)];
    if haspoints
        enstate=[enstate; {'on'}];
    else
        enstate=[enstate; {'off'}];
    end
end
if root~=ud.menustates.root || guilocked~=ud.menustates.guilocked
   hndls=[hndls; handle(ud.File.Delete); ud.Toolbar.Delete; handle(ud.TreeContext.delete)];
   if root || guilocked
      enstate=[enstate;repmat({'off'},3,1)];
   else
      enstate=[enstate;repmat({'on'},3,1)];
   end
end
if lock~=ud.menustates.lock || haspoints~=ud.menustates.haspoints || guilocked~=ud.menustates.guilocked
   hndls=[hndls; handle(ud.Edit.Clear); handle(ud.Edit.Delete); handle(ud.Edit.Sort); handle(ud.Edit.Fix);...
         ud.Toolbar.DelPoint; ud.Toolbar.Sort; handle(ud.Edit.Randomize); handle(ud.Edit.Round)];
   if lock || ~haspoints || guilocked
      enstate=[enstate;repmat({'off'},8,1)];
   else
      enstate=[enstate;repmat({'on'},8,1)];
   end
end
if lock~=ud.menustates.lock || optim~=ud.menustates.optim || guilocked~=ud.menustates.guilocked
   hndls=[hndls; handle(ud.Design.Optimal); ud.Toolbar.Optimal];
   if lock || ~optim || guilocked
      enstate=[enstate;repmat({'off'},2,1)];
   else
      enstate=[enstate;repmat({'on'},2,1)];
   end
   ud.menustates.optim=optim;
end
if lock~=ud.menustates.lock || guilocked~=ud.menustates.guilocked
   hndls=[hndls; handle(ud.Edit.Add); handle(ud.Edit.Constraints); handle(ud.Edit.Model); handle(ud.Design.Classical);...
      handle(ud.Design.SpaceFill); ud.Toolbar.AddPoint; ud.Toolbar.Classical; ud.Toolbar.SpaceFill; handle(ud.File.ConImport)];
   if lock || guilocked
      enstate=[enstate;repmat({'off'},9,1)];
   else
      enstate=[enstate;repmat({'on'},9,1)];
   end
end
if onchosen~=ud.menustates.onchosen || guilocked~=ud.menustates.guilocked ...
      || root~=ud.menustates.root
   hndls=[hndls; handle(ud.Edit.Select)];
   if root || onchosen || guilocked
      enstate=[enstate; {'off'}];
   else
      enstate=[enstate; {'on'}];
   end
end
if guilocked~=ud.menustates.guilocked
   hndls=[hndls; handle(ud.File.Import); handle(ud.File.New); ...
           ud.Toolbar.New; handle(ud.TreeContext.new); handle(ud.File.Merge)];
   if guilocked
      enstate=[enstate;repmat({'off'},5,1)];
   else
      enstate=[enstate;repmat({'on'},5,1)];
   end
end
ud.menustates.root=root;
ud.menustates.lock=lock;
ud.menustates.optim=optim;
ud.menustates.haspoints=haspoints;
ud.menustates.guilocked=guilocked;
ud.menustates.onchosen=onchosen;
pmenu.info=ud;
if length(hndls)
   set(ud.Toolbar.Layout,'toolbardraw','off');
   set(hndls,{'enable'},enstate);
   set(ud.Toolbar.Layout,'toolbardraw','on');
end
return



function i_ScanForDesigns(srcobj,evt,desclass,dp,pmain,psbar)
% set up list of classical/spacefill designs
csI=csetinterface;
csI=set(csI,'typefilter',desclass);
fnm=get(csI,'FullNames');
ch=get(srcobj,'children');
if (length(ch)-1)~=length(fnm)
   % Re-create set of options
   if length(ch)>1
      delete(ch(2:end));
   end
   cls=get(csI,'ClassNames');
   u=zeros(1,length(fnm));
   % create uimenus
   for n=1:length(fnm)
      u(n)=uimenu('parent',srcobj,'callback',{@i_defineddesign,dp,psbar,pmain,cls{n}});
   end
   set(u,'interruptible','off',{'label'},fnm(:));
   set(u(1),'separator','on');
   set(srcobj,'userdata',u);
end

% check enable setting on menu items - disallow if csets do not support nf factors
nf=nfactors(dp.getdesign);
ch=get(srcobj,'userdata');
enstates=getenablestates(csI,nf);
set(ch,{'enable'},enstates);
return


function i_checkviewer(src,evt,pview)
ud=pview.info;
cls=class(ud.currentviewer);
vl=xregdesgui.viewerlist;
opts=get(vl,'Constructors');
opts=opts(end:-1:1);
idx=strmatch(cls,opts,'exact');

checks=repmat({'off'},length(opts),1);
if ~isempty(idx)
   checks(idx)={'on'};
end
set(get(src,'children'),{'checked'},checks);
return


function i_setoptionsmenu(src,evt,pview,pmenus)
viewud=pview.info;
menuud=pmenus.info;
opts=viewud.currentviewer.OptionFunctions;
ch=get(src,'children');
if ~isempty(opts)
   Nitems=size(opts,2); 
   set(ch(1:Nitems),'visible','on',...
      {'label'},opts(1,:)',...
      {'userdata'},opts(2,:)'); 
   set(ch(Nitems+1:end),'visible','off');
else
   set(ch,'visible','off');
end
return


function i_CheckForDeleteView(src,evt,pview,dp,pmenus)
des = dp.getdesign;
viewud = pview.info;
menuud = pmenus.info;

currentud = viewud.viewgroup.SelectedView.UserData;
if isempty(des) || ~isa(currentud.parent,'xregsplitlayout')
    set(menuud.View.Delete,'enable','off');
else
    set(menuud.View.Delete,'enable','on');
end

% also check for options/not
opts = viewud.currentviewer.OptionFunctions;
if isempty(des) || isempty(opts)
    set(menuud.View.Options.this,'enable','off');
else
    set(menuud.View.Options.this,'enable','on');
end

% force callback execution
figure(get(src,'Parent'));
return


function i_ContextView(src,evt,pview,dp,pmenus)
des = dp.getdesign;
viewud = pview.info;
menuud = pmenus.info;
currentud = viewud.viewgroup.SelectedView.UserData;
if isempty(des) || ~isa(currentud.parent,'xregsplitlayout')
    set(menuud.Context.Delete,'enable','off');
else
    set(menuud.Context.Delete,'enable','on');
end

% check correct viewer in Current View menu
i_checkviewer(menuud.Context.Current, [], pview);

% look for options
opts = viewud.currentviewer.OptionFunctions;
if isempty(des) || isempty(opts)
    set(menuud.Context.Options.this,'enable','off');
else
    set(menuud.Context.Options.this,'enable','on');
    i_setoptionsmenu(menuud.Context.Options.this, [], pview,pmenus);
end
return


function i_TreeContextView(src,evt,dp,pmenus)
% Check that eval gui is an option
des=dp.getdesign;
menuud=pmenus.info;
if isempty(des)
   set([menuud.TreeContext.eval;menuud.TreeContext.props],'enable','off');
else
   if isoptimcapable(des)
      set(menuud.TreeContext.eval,'enable','on');
   else
      set(menuud.TreeContext.eval,'enable','off');
   end
   set(menuud.TreeContext.props,'enable','on');
end

function i_dooptions(src,evt,pview)
% get function handle to call
fn=get(src,'userdata');
viewud=pview.info;
feval(fn,viewud.currentviewer);


function i_doviewerenables(pmenus,pmain)
% disable viewers that are not useful for this many factors
menuud=pmenus.info;
des=i_getdesign(pmain,1);  % get root design
nf=nfactors(des);
vl=xregdesgui.viewerlist;
en=(vl.MinFactors<=nf);
en=en(end:-1:1);
ch=get(menuud.View.Current,'children');
set(ch(en),'enable','on');
set(ch(~en),'enable','off');
ch=get(menuud.Context.Current,'children');
set(ch(en),'enable','on');
set(ch(~en),'enable','off');
return



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                          %
%  Command callbacks from menu/toolbar/keyboard            %
%                                                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function o______COMMAND_CALLBACKS
function i_newdesign(src,evt,pmain,ptree,pmenu)
% get current design as template for new one
[des,ind]= i_getcurrentdesign(pmain);
if ~i_getguilocked(pmain)
   newdes=setlock(des,0);
end
% get a unique name for the design
newdes= name(newdes,i_uniquename(ptree,name(newdes)));

isfirstchild=~i_iscurrentaparent(ptree);

% add a new node to tree
i_addtotree(ptree,newdes);

% add the new design to list
i_addtodesignlist(pmain,newdes);

if ind~=1
   % lock current node
   i_lockcurrentdesign(pmain)
elseif ind==1 & isfirstchild
   % if on root _and_ tree is empty, move to new design
   i_selectnodeontree(ptree,2);  % this must be first child design made on the tree if we are here
   i_treenodeclick(pmain,ptree,[],1);
end
return


function i_removedesign(src,evt,pmain,ptree)
% post message to statusbar
msgID=i_addmessage(ptree.info.sbar,'Removing design...');

current_node=i_getcurrenttreenode(ptree);
if ~isempty(current_node)
   ind=double(current_node.index);
else
   ind=1;
end

if ind~=1
   nodes_to_delete= [ind, i_getallchildren(current_node)];
   warn=0;
   % check all children to look for the chosen best design
   chind=i_getchosen(pmain);
   if ~isempty(chind)
      if any(nodes_to_delete==chind)
         warn=1;
      end
   end
   if warn
      if ~i_getchosenlocked(pmain)
         answ=questdlg(['The designs you have chosen to delete include the current "Best Design".  ',...
               'Do you wish to continue with the deletion or cancel the operation?'],...
            'MBC Toolbox','Continue','Cancel','Cancel');
         if strcmp(answ,'Cancel')
            % Remove message
            i_deletemessage(ptree.info.sbar,msgID);
            return
         else
            i_unchoosedesign(pmain,ptree);
         end
      else
         % chosen design is locked - can't delete it
         h=errordlg(['The designs you have chosen to delete include the current "Best Design".  ',...
               'This design is currently in use and cannot be altered or deleted.  Please change ',...
               'your selection and try again.'],'MBC Toolbox');
         waitfor(h);
         i_deletemessage(ptree.info.sbar,msgID);
         return
      end
   else
      % general warning
      answ=questdlg(['Do you want to delete the design "' current_node.text '" and all of its sub-designs?'],'MBC Toolbox','Yes','No','Yes');
      if strcmp(answ,'No')
         % Remove message
         i_deletemessage(ptree.info.sbar,msgID);
         return
      end
   end
   
   % delete nodes from tree
   i_deletenode(ptree,current_node);
   
   % delete data from main datastore
   i_removefromdesignlist(pmain,nodes_to_delete);  
   
   % force a tree selection event
   i_treenodeclick(pmain,ptree,[],1);
   
   % check new current design for children
   des=i_getcurrentdesign(pmain);
   if i_getguilocked(pmain) || i_iscurrentaparent(ptree)
      i_lockcurrentdesign(pmain);
   else
      i_unlockcurrentdesign(pmain);
   end
   % update tree icon
   i_updatenode(pmain,ptree);
end
% Remove message
i_deletemessage(ptree.info.sbar,msgID);
return


function i_cleardesign(src,evt,dp,psbar,pmain)

answer=questdlg(['Warning: this operation will delete all of your current design points',...
      ' from this design.  Do you want to continue?'],...
   'MBC Toolbox',...
   'Yes','No','No');

if strcmp(answer,'Yes')
   % post message to statusbar
   msgID=i_addmessage(psbar,'Clearing design points...');
   ptrID=i_setpointer(pmain,'watch');
   des=dp.getdesign;
   des=clear(des);
   dp.setdesign(des,'design');
   
   % Remove message
   i_deletemessage(psbar,msgID);
   i_deletepointer(pmain,ptrID);
end
return


function i_addpoints(src,evt,dp,psbar,pmain)
msgID=i_addmessage(psbar,'Adding design points...');
ptrID=i_setpointer(pmain,'watch');
des=dp.getdesign;
[des,ok]=gui_addpoints(des);
if ok
   % update
   dp.setdesign(des,'design');
end
% Remove message
i_deletemessage(psbar,msgID);
i_deletepointer(pmain,ptrID);
return

function i_delpoints(src,evt,dp,psbar,pmain)
msgID=i_addmessage(psbar,'Deleting design points...');
ptrID=i_setpointer(pmain,'watch');
des=dp.getdesign;
[des,ok]=gui_deletepoints(des);
if ok
   % update
   dp.setdesign(des,'design');
end
% Remove message
i_deletemessage(psbar,msgID);
i_deletepointer(pmain,ptrID);
return

function i_sortpoints(src,evt,dp,psbar,pmain)
msgID=i_addmessage(psbar,'Sorting design points...');
ptrID=i_setpointer(pmain,'watch');
des=dp.getdesign;
[des,ok]=gui_sort(des);
if ok
   % update
   dp.setdesign(des,'design');
end
% Remove message
i_deletemessage(psbar,msgID);
i_deletepointer(pmain,ptrID);
return

function i_fixpoints(src,evt,dp,psbar,pmain)
msgID=i_addmessage(psbar,'Fixing design points...');
ptrID=i_setpointer(pmain,'watch');
des=dp.getdesign;
[des,ok]=gui_fixpoints(des);
if ok
   % update
   dp.setdesign(des,'design');
end
% Remove message
i_deletemessage(psbar,msgID);
i_deletepointer(pmain,ptrID);
return

function i_randomize(src,evt,dp,psbar,pmain)
msgID=i_addmessage(psbar,'Randomizing design points...');
ptrID=i_setpointer(pmain,'watch');
des=dp.getdesign;
des = reorder(des, randperm(npoints(des)));
dp.setdesign(des,'design');
% Remove message
i_deletemessage(psbar,msgID);
i_deletepointer(pmain,ptrID);
return

function i_round(src,evt,dp,psbar,pmain)
msgID = i_addmessage(psbar,'Rounding design points...');
ptrID = i_setpointer(pmain,'watch');
des = dp.getdesign;
[des, ok] = gui_round(des);
if ok
    % update views
    dp.setdesign(des,'design');
end
% Remove message
i_deletemessage(psbar,msgID);
i_deletepointer(pmain,ptrID);
return

function i_constraints(src,evt,dp,psbar,pmain)
msgID=i_addmessage(psbar,'Editing Constraints...');
ptrID=i_setpointer(pmain,'watch');
des=dp.getdesign;
[des,ok]=constrainteditor(des,'figure');
% update changed info now
des=updatestores(des);
if ok==1
   % update
   dp.setdesign(des,'constraint');
elseif ok==2
   % update constraints and design
   dp.setdesign(des,'constraint');
   dp.setdesign(des,'design');
end
% Remove message
i_deletemessage(psbar,msgID);
i_deletepointer(pmain,ptrID);
return

function i_optimaldesign(src,evt,dp,psbar,pmain)
msgID=i_addmessage(psbar,'Creating Optimal Design...');
ptrID=i_setpointer(pmain,'watch');
des=dp.getdesign;
[des,ok]=gui_optimal(des);
if ok
   % update
   dp.setdesign(des,'design');
end
% Remove message
i_deletemessage(psbar,msgID);
i_deletepointer(pmain,ptrID);
return

function i_defineddesign(src,evt,dp,psbar,pmain,cs)
msgID=i_addmessage(psbar,'Creating Design...');
ptrID=i_setpointer(pmain,'watch');
des=dp.getdesign;
[des,ok]=gui_predef(des,cs);
if ok
   % update
   dp.setdesign(des,'design');
end
% Remove message
i_deletemessage(psbar,msgID);
i_deletepointer(pmain,ptrID);
return

function i_model(src,evt,dp,psbar,pmain)
msgID=i_addmessage(psbar,'Editing model...');
ptrID=i_setpointer(pmain,'watch');
des=dp.getdesign;
m=model(des);

ud=pmain.info;
if ud.numstages>1
   if ud.currentstage>1
      [m,ok]= gui_ModelSetup(m,'criteria','global');
   else
      [m,ok]= gui_ModelSetup(m);
   end
else
   [m,ok]=gui_ModelSetup(m);
end

if ok
   % update   
   pre_lims=gettarget(model(des));
   post_lims=gettarget(m);
   numC=numConstraints(des);
   doupdate=0;
   updatestring='model';
   if numC && any(pre_lims(:)~=post_lims(:))
      answer=questdlg(['Changing to this model invalidates the constraints you have defined ' ...
            'and they will be deleted from the design.  Do you want to continue?'],...
         'MBC Toolbox','OK','Cancel','OK');
      if strcmp(answer,'OK')
         doupdate=1;
         updatestring='item';
      end
   else
      doupdate=1;
   end
   if doupdate
      des=model(des,m);
      dp.setdesign(des,updatestring);
   end
end
% Remove message
i_deletemessage(psbar,msgID);
i_deletepointer(pmain,ptrID);
return

function i_properties(src,evt,dp,pmain)
ptrID=i_setpointer(pmain,'watch');
des=dp.getdesign;
[des,ok]=propdlg(des);
if ok
   % update
   dp.setdesign(des,'design');
end
% Remove message
i_deletepointer(pmain,ptrID);
return

function i_export(src,evt,dp,pmain,psbar)
msgID=i_addmessage(psbar,'Exporting design...');
ptrID=i_setpointer(pmain,'watch');
des=dp.getdesign;
gui_export(des);
% Remove message
i_deletemessage(psbar,msgID);
i_deletepointer(pmain,ptrID);
return

function i_import(src,evt,dp,ptree,pmain,psbar)
msgID=i_addmessage(psbar,'Importing design...');
ptrID=i_setpointer(pmain,'watch');
mainud=pmain.info;
% use base design as input to import routine
des=mainud.pdesigns(1).info;
[des,ok]= gui_import(des);
if ok
   % get a unique name for the design
   des=name(des,i_uniquename(ptree,name(des)));
   % add to tree and data
   i_addtotree(ptree,des,1);
   i_addtodesignlist(pmain,des);
   % switch to design
   Ndes=i_getnumberofdesigns(pmain);
   i_selectnodeontree(ptree,Ndes+1);
   i_treenodeclick(pmain,ptree,[],Ndes);
end
% Remove message
i_deletemessage(psbar,msgID);
i_deletepointer(pmain,ptrID);
return

function i_selectdes(src,evt,ptree,pmain)
[d,ind] = i_getcurrentdesign(pmain);
if i_getchosenlocked(pmain)
    % check the new design is ok with the current matched design
    chind = i_getchosen(pmain);
    if isempty(chind)
        ok = true;
    else
        refd = i_getdesign(pmain, chind);
        [d,ok] = checkdesignmatch(d,refd);
    end
    if ok
        pmain.info.pcurrent.setdesign(d,'design');
    else
        h = errordlg(['This design cannot be chosen as the Best Design because it',...
                ' does not include the design points which have already been matched.',...
                '  Check the current Best Design and make sure you have included all of',...
                ' it''s fixed points in the new design.'],'Error','modal');
        waitfor(h);
        return
    end   
end

% first deselect current best design
i_unchoosedesign(pmain,ptree);
i_setchosen(pmain,ind);
% lock design
i_lockcurrentdesign(pmain);
% update tree node
i_updatenode(pmain,ptree);
return


function i_importcon(src,evt,dp,pmain,psbar)
msgID=i_addmessage(psbar,'Importing constraints...');

des=dp.getdesign;
mainud=pmain.info;
pdes=mainud.pdesigns;
pdes=pdes(2:end);
% remove the current design
pdes(mainud.currentind-1)=[];

if length(pdes)
   for n=length(pdes):-1:1
      deslist{n}=pdes(n).info;
   end
else
   deslist={};
end

[des,ok]=importconstraints(des,deslist);
if ok==2
   des=updatestores(des);
   dp.setdesign(des,'constraint');
elseif ok==3
    des=updatestores(des);
    dp.setdesign(des,'all');
end
i_deletemessage(psbar,msgID);
return


function i_startrenamedesign(src,evt,ptree)
ud=ptree.info;
ud.tree.StartLabelEdit;
return

function i_mergedesigns(src, evt, dp, psbar, pmain, ptree)
msgID = i_addmessage(psbar,'Merging designs...');
ptrID = i_setpointer(pmain,'watch');

if pmain.info.currentind==1
    [des, ok, exist] = gui_merge(xregdesign, get(pmain.info.pdesigns(2:end), {'info'}), []);
else
    des = dp.getdesign;
    [des, ok, exist] = gui_merge(des, get(pmain.info.pdesigns(2:end), {'info'}), pmain.info.currentind-1);
end
if ok
    if exist>0
        % push result back into existing design
        if exist==pmain.info.currentind-1
            % Design is the current one
            dp.setdesign(des,'design');
        else
            % Other design on the tree
            i_setdesign(pmain, des, exist+1);
            i_updatenode(pmain, ptree, exist+1);
        end
    else
        % Add new design to the tree
        % get a unique name for the design
        des = name(des, i_uniquename(ptree,name(des)));
        % add to tree and data
        i_addtotree(ptree, des, 1);
        i_addtodesignlist(pmain, des);
    end
end
% Remove message
i_deletemessage(psbar,msgID);
i_deletepointer(pmain,ptrID);
return




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                          %
%  Statusbar interface                                     %
%                                                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function o________________STATUSBAR  % dummy function header puts a break in function listing!
function newid=i_addmessage(psbar,msg)
% add a message to the statusbar queue
ud = psbar.info;
newid = ud.panel.addMessage(msg);

function i_deletemessage(psbar,id)
% remove a message from the statusbar queue
if ~isempty(id)
    ud = psbar.info;
    ud.panel.removeMessage(id);
end

function i_clearsbar(psbar)
ud = psbar.info;
ud.panel.clearMessage;
ud.panel.addMessage('Ready');
psbar.info = ud;
