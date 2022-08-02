function out=propertypage(obj,action,varargin);
% PROPERTYPAGE  Create a property gui for CandidateSet
%
%
%   This should be overloaded by child classes
%
%   Property pages 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:00:50 $




switch lower(action)
case 'layout'
   out=i_createlyt(varargin{:});
case 'update'
   out=i_update(varargin{:});
end
return



function lyt=i_createlyt(figh,varargin)

% create new layout in figure
ud.pointer=[];
ud.figure=figh;
ud.model=[];
ud.callback='';
ud.rbgvalue=1;
if nargin>1
   for n=1:2:length(varargin)
      switch lower(varargin{n})
      case 'callback'
         ud.callback=varargin{n+1};
      end
   end
end

ud.lstbox=uicontrol('parent',figh,...
   'visible','off',...
   'backgroundcolor','w',...
   'value',1,...
   'style','listbox',...
   'interruptible','off');
ud.mintxt=uicontrol('parent',figh,...
   'style','text',...
   'visible','off',...
   'horizontalalignment','left',...
   'position',[0 0 110 15]);
ud.maxtxt=uicontrol('parent',figh,...
   'style','text',...
   'visible','off',...
   'horizontalalignment','left',...
   'position',[0 0 110 15]);
ud.minedt=uicontrol('parent',figh,...
   'style','edit',...
   'backgroundcolor','w',...
   'visible','off',...
   'position',[0 0 70 20],...
   'interruptible','off');
ud.maxedt=uicontrol('parent',figh,...
   'style','edit',...
   'backgroundcolor','w',...
   'visible','off',...
   'position',[0 0 70 20],...
   'interruptible','off');
ud.nlvltxt=uicontrol('parent',figh,...
   'style','text',...
   'visible','off',...
   'horizontalalignment','left',...
   'position',[0 0 110 15]);
ud.nlvledt=xregGui.clickedit(figh,...
   'min',2,...
   'max',1000,...
   'clickincrement',1,...
   'dragincrement',1,...
   'rule','int',...
   'position',[0 0 70 20],...
   'visible','off');
ud.rbg=[xreguicontrol('parent',figh,'style','radiobutton',...
      'visible','off','string','Equally spaced levels',...
      'interruptible','off','value',1);...
      xreguicontrol('parent',figh,'style','radiobutton',...
      'visible','off','string','User-specified levels',...
      'interruptible','off')];
ud.lvledt=uicontrol('parent',figh,...
   'style','edit',...
   'backgroundcolor','w',...
   'visible','off',...
   'enable','off',...
   'horizontalalignment','left',...
   'interruptible','off');

% callbacks
udh=ud.lstbox;
set(ud.lstbox,'callback',{@i_fact,udh});
set(ud.minedt,'callback',{@i_min,udh});
set(ud.maxedt,'callback',{@i_max,udh});
set(ud.nlvledt,'callback',{@i_nlevels,udh});
set(ud.lvledt,'callback',{@i_levels,udh});
set(ud.rbg,{'callback'},{{@i_method,udh,1};{@i_method,udh,2}});

% flw1=xregflowlayout(figh,'packstatus','off','orientation','left/center',...
%    'elements',{txt1});
% flw2=xregflowlayout(figh,'orientation','left/center','gap',10,...
%    'elements',{ud.mintxt,ud.minedt});
% flw3=xregflowlayout(figh,'orientation','left/center','gap',10,...
%    'elements',{ud.maxtxt,ud.maxedt});
% flw4=xregflowlayout(figh,'orientation','left/center','gap',10,...
%    'elements',{ud.nlvltxt,ud.nlvledt});
% flw5=xregflowlayout(figh,'orientation','left/center',...
%    'elements',{txt2});
% grd=xreggridbaglayout(figh,'dimension',[5 1],'correctalg','on',...
%    'elements',{flw1,flw2,flw3,flw4,flw5});
% brd1=xregborderlayout(figh,'center',grd,'west',ud.rbg,'innerborder',[20 0 0 0]);
% layerl=xreglayerlayout(figh,'elements',{ud.lvledt},'border',[30 0 0 0]);
% brd2=xregborderlayout(figh,'north',brd1,'center',layerl,'innerborder',[0 0 0 120]);
% lyt=xregsplitlayout(figh,...
%    'left',ud.lstbox,...
%    'right',brd2,...
%    'split',[.25 .75],...
%    'leftinnerborder',[0 5 0 0],...
%    'rightinnerborder',[0 0 0 5],...
%    'resizable','off');

lyt=xreggridbaglayout(figh,'dimension',[17 5],...
   'rowsizes',[20 5 3 15 2 5 3 15 2 5 3 15 2 5 20 5 -1],...
   'colsizes',[-1 10 15 -1 70],...
   'colratios',[.3 0 0 .7 0],...
   'mergeblock',{[1 17],[1 1]},...    % listbox
   'mergeblock',{[1 1],[3 5]},...     % radiobutton
   'mergeblock',{[15 15],[3 5]},...   % radiobutton
   'mergeblock',{[3 5],[5 5]},...
   'mergeblock',{[7 9],[5 5]},...
   'mergeblock',{[11 13],[5 5]},...
   'mergeblock',{[17 17],[4 5]},...
   'elements',{ud.lstbox,[],ud.rbg(1),[],[];...
      [],[],[],[],[];...
      [],[],[],[],ud.minedt;...
      [],[],[],ud.mintxt,[];...
      [],[],[],[],[];...
      [],[],[],[],[];...
      [],[],[],[],ud.maxedt;...
      [],[],[],ud.maxtxt,[];...
      [],[],[],[],[];...
      [],[],[],[],[];... 
      [],[],[],[],ud.nlvledt;...
      [],[],[],ud.nlvltxt,[];...
      [],[],[],[],[];...
      [],[],[],[],[];...
      [],[],ud.rbg(2),[],[];...
      [],[],[],[],[];...
      [],[],[],ud.lvledt,[]},...
   'userdata',udh);
   
ud.layout=lyt;
set(udh,'userdata',ud);
return


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% External update function.  Finds udh the dirty way %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function lyt=i_update(lyt,p,m)
udh=get(lyt,'userdata');
ud=get(udh,'userdata');
ud.pointer=p;
ud.model=m;
ud=i_setvalues(ud);
set(ud.lstbox,'userdata',ud);
return



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set all strings, values etc from data in udh %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ud=i_setvalues(ud)
% set up the listbox
fact=get(ud.model,'symbol');
set(ud.lstbox,'string',fact);

factnum=get(ud.lstbox,'value');
fact=fact{factnum};
cs=ud.pointer.info;
set([ud.mintxt;ud.maxtxt;ud.nlvltxt],{'string'},...
   {['Minimum ' fact ' value:'];['Maximum ' fact ' value:'];['Number of levels for ' fact ':']});

lvls=get(cs,'levels');
lvls=lvls{factnum};
lvls=invcode(ud.model,lvls(:),factnum);
set([ud.minedt;ud.maxedt],{'string'},...
   {min(lvls);max(lvls)});
set(ud.nlvledt,'value',length(lvls));
str=prettify(lvls);
set(ud.lvledt,'string',str);
sc=xregGui.SystemColorsDbl;
% decide if the str represents a number of equal levels
if (length(findstr(str,':'))<=2 & isempty(findstr(str,' '))) | length(lvls)==2
   % use set levels
   set(ud.rbg,{'value'},{1;0});
   % set enable statuses
   set(ud.lvledt,'enable','off','backgroundcolor',sc.CTRL_BACK);
   set([ud.mintxt;ud.maxtxt;ud.nlvltxt],'enable','on');
   set([ud.minedt;ud.maxedt],'enable','on','backgroundcolor',[1 1 1]);
   set(ud.nlvledt,'enable','on','backgroundcolor',[1 1 1]);
   ud.rbgvalue=1;
else
   set(ud.rbg,{'value'},{0;1});
   set(ud.lvledt,'enable','on','backgroundcolor','w');
   set([ud.mintxt;ud.maxtxt;ud.nlvltxt],'enable','off');
   set([ud.minedt;ud.maxedt],'enable','off','backgroundcolor',sc.CTRL_BACK);
   set(ud.nlvledt,'enable','off','backgroundcolor',sc.CTRL_BACK);
   ud.rbgvalue=2;
end
return


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Callbacks from each object %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function i_fact(obj,nul,udh)
ud=get(udh,'userdata');
ud=i_setvalues(ud);
set(udh,'userdata',ud);
return

function i_max(obj,nul,udh)
ud=get(udh,'userdata');
factnum=get(ud.lstbox,'value');
mxval=str2double(get(ud.maxedt,'string'));
mxval=code(ud.model,mxval,factnum);
cs=ud.pointer.info;
lvls=get(cs,'levels');
lims=lvls{factnum};
mnval=min(lims);

if isempty(mxval) | length(mxval)~=1 | mnval>=mxval | isnan(mxval)
   % reset display
   lims=invcode(ud.model,lims(:),factnum);
   set(ud.maxedt,'string',max(lims));
else
   % recreate levels vector
   nlvls=get(ud.nlvledt,'value');
   lvls{factnum}=linspace(mnval,mxval,nlvls);
   cs=set(cs,'levels',lvls);
   set(ud.lvledt,'string',prettify(invcode(ud.model, lvls{factnum}', factnum)'));
   ud.pointer.info=cs;
   set(udh,'userdata',ud);
   i_firecb(ud);
end
return

function i_min(obj,nul,udh)
ud=get(udh,'userdata');
factnum=get(ud.lstbox,'value');
mnval=str2double(get(ud.minedt,'string'));
mnval=code(ud.model,mnval,factnum);
cs=ud.pointer.info;
lvls=get(cs,'levels');
lims=lvls{factnum};
mxval=max(lims);

if isempty(mnval) | length(mnval)~=1 | mnval>=mxval | isnan(mnval)
   % reset display
   lims=invcode(ud.model,lims(:),factnum);
   set(ud.minedt,'string',min(lims));
else
   % recreate levels vector
   nlvls=get(ud.nlvledt,'value');
   lvls{factnum}=linspace(mnval,mxval,nlvls);
   cs=set(cs,'levels',lvls);
   set(ud.lvledt,'string',prettify(invcode(ud.model, lvls{factnum}', factnum)'));
   ud.pointer.info=cs;
   set(udh,'userdata',ud);
   i_firecb(ud);
end
return

function i_nlevels(obj,nul,udh)
ud=get(udh,'userdata');
nlvls=get(obj,'value');
factnum=get(ud.lstbox,'value');
cs=ud.pointer.info;
lvls=get(cs,'levels');
mnval=min(lvls{factnum}(:));
mxval=max(lvls{factnum}(:));
lvls{factnum}= linspace(mnval,mxval,nlvls);
cs=set(cs,'levels',lvls);
ud.pointer.info=cs;
% update levels edit box
set(ud.lvledt,'string',prettify(invcode(ud.model, lvls{factnum}', factnum)'));
set(udh,'userdata',ud);
i_firecb(ud);
return

function i_levels(obj,nul,udh)
ud=get(udh,'userdata');
lvl=str2num(get(ud.lvledt,'string'));
factnum=get(ud.lstbox,'value');
cs=ud.pointer.info;
lvls=get(cs,'levels');
if ~isempty(lvl) & isnumeric(lvl) & length(unique(lvl))>1
   lvls{factnum}=code(ud.model,lvl(:),factnum)';
   set([ud.minedt;ud.maxedt],{'string'},{min(lvl(:));max(lvl(:))});
   set(ud.nlvledt,'value',length(lvl));
   cs=set(cs,'levels',lvls);
   ud.pointer.info=cs;
   set(udh,'userdata',ud);
   i_firecb(ud);
else
   lvl=(invcode(ud.model,lvls{factnum}(:),factnum))';
end
set(ud.lvledt,'string',prettify(lvl));
return

function i_method(obj,nul,udh,val)
ud=get(udh,'userdata');
% switch enable status of bits
sc=xregGui.SystemColorsDbl;
if val~=ud.rbgvalue
   switch val
   case 1
      set(ud.rbg(2),'value',0);
      set(ud.lvledt,'enable','off','backgroundcolor',sc.CTRL_BACK);
      set([ud.mintxt;ud.maxtxt;ud.nlvltxt],'enable','on');
      set([ud.minedt;ud.maxedt],'enable','on','backgroundcolor',[1 1 1]);
      set(ud.nlvledt,'enable','on','backgroundcolor',[1 1 1]);
      % reset levels edit box using min/max/nlevels
      i_nlevels(ud.nlvledt,[],udh);
   case 2
      set(ud.rbg(1),'value',0);
      set([ud.mintxt;ud.maxtxt;ud.nlvltxt],'enable','off');
      set([ud.minedt;ud.maxedt],'enable','off','backgroundcolor',sc.CTRL_BACK);
      set(ud.nlvledt,'enable','off','backgroundcolor',sc.CTRL_BACK);
      set(ud.lvledt,'enable','on','backgroundcolor',[1 1 1]); 
   end
   ud.rbgvalue=val;
   set(udh,'userdata',ud);
else
   set(ud.rbg(val),'value',1);
end
return


function i_firecb(ud)
if ischar(ud.callback)
   evalin('base',ud.callback);
else
   str=[ud.callback(1) {ud.layout,[]} ud.callback(2:end)];
   feval(str{:});
end
return
