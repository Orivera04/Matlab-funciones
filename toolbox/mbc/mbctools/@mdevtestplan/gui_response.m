function [varargout]=gui_response(T,action,varargin)
% GUI_RESPONSE  GUI for altering response model settings
%
%  [M,OK]=GUI_RESPONSE(TP,M) creates a modal dialog for selecting the
%  response model type.  TP is the testplan, M is the current model.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.6.4.3 $  $Date: 2004/02/09 08:07:52 $


if nargin<2
   action='figure';
end

switch lower(action)
case 'figure'
   [ varargout{1:2}]=i_createfig(T);   
case 'layout'
   varargout{1}=i_createlyt(varargin{:});
case 'update'
   
   for i=1:length(T.Responses)
      % copy name to response
      m= T.Responses{i};
      yi= yinfo(m);
      yi.Symbol= yi.Name;
      T.Responses{i}= yinfo(m,yi);
   end
   
   xregpointer(T);
   
   
   varargout= {T,1};
   
   
end



%----------------------------------------------------
% SUBFUNCTION i_createfig
%----------------------------------------------------
function [T,ok]=i_createfig(T)
scsz=get(0,'screensize');
pt= get(0,'PointerLocation');
fpos= [pt(1)-280 pt(2)-320 570 300];
if fpos(1)<0
   fpos(1)= 20;
end
if fpos(2)<0
   fpos(2) = 20;
end

figh=xregfigure('menubar','none',...
   'toolbar','none',...
   'numbertitle','off',...
   'name','Response Model Setup',...
   'doublebuffer','on',...
   'renderer','zbuffer',...
   'closerequestfcn','set(gcbf,''tag'',''cancel'');',...
   'position',fpos,...
   'visible','off',...
   'color',get(0,'defaultuicontrolbackgroundcolor'),...
   'tag','ResponseModSetup',...
   'resize','off');
figh= double(figh);

p=address(T);
[lyt,ud]=i_createlyt(figh,p);


% ok and cancel buttons
okbtn = uicontrol('parent',figh,...
   'string','OK',...
   'style','pushbutton',...
   'callback','set(gcbf,''tag'',''ok'');',...
   'position',[0 0 65 25]);
cancbtn = uicontrol('parent',figh,...
   'string','Cancel',...
   'style','pushbutton',...
   'callback','set(gcbf,''tag'',''cancel'');',...
   'position',[0 0 65 25]);
helpbtn = mv_helpbutton(figh,'xreg_responseSetup');
set(helpbtn,'position',[0 0 65 25]);

flw=xregflowlayout(figh,'orientation','right/bottom',...
   'elements',{helpbtn,cancbtn,okbtn},...
   'gap',7,...
   'border',[0 10 -7 10]);
brd=xregborderlayout(figh,'center',lyt,'south',flw,...
   'innerborder',[10 45 10 10],...
   'container',figh,...
   'packstatus','on');

set(figh,'visible','on');
drawnow;
set(figh,'windowstyle','modal');

waitfor(figh,'tag');

tg=get(figh,'tag');
switch lower(tg)
case 'ok'
   
   T= gui_response(p.info,'update');
   
   ok=1;
   
case 'cancel'
   mdout=T;
   pointer(mdout);
   ok=0;
end
% don't free pointer - it's a dynamic copy that's shared by everyone!
delete(figh);
return




%----------------------------------------------------
% SUBFUNCTION i_createlyt
%----------------------------------------------------
function [lyt,ud]=i_createlyt(figh,p);

if isa(figh,'xregcontainer')
   fH= allchild(0);
   % figure should be on the top
   udh= findobj(fH(1),'tag','tprespmodelgui');
   ud= get(udh,'userdata');
   
   i_setvalues(ud);
   lyt= figh;
   return
   
end



ud.figh=figh;
ud.pointer=p;
T= p.info;

bgcol=get(figh,'defaultuicontrolbackgroundcolor');

%% label for list of data variables
ytxt=uicontrol('style','text',...
   'parent',figh,...
   'horizontalalignment','left',...
   'string','Data Variables',...
   'fontweight','bold',...
   'tag','tprespmodelgui',...
   'position',[0 0 50 15]);
% data
udh=ytxt;

%% listbox of data variables
ud.ylist=uicontrol('style','listbox',...
   'parent',figh,...
   'position',[0 0 20 20],...
   'backgroundcolor','w',...
   'interruptible','off');

ylyt= xreggridlayout(figh,...
   'dimension',[2 1],...
   'elements',{ytxt,ud.ylist},...
   'correctalg','on',...
   'rowsizes',[15 -1]);

%% label for list of responses
rtxt=uicontrol('style','text',...
   'parent',figh,...
   'horizontalalignment','left',...
   'string','Responses',...
   'fontweight','bold',...
   'position',[0 0 50 15]);
%% listbox of responses
ud.rlist=uicontrol('style','listbox',...
   'parent',figh,...
   'position',[0 0 20 20],...
   'backgroundcolor','w',...
   'callback',{@i_SelectModel,udh},...
   'interruptible','off');

ud.DelBtn=uicontrol('style','pushbutton',...
   'parent',figh,...
   'string','Delete',...
   'tooltipstring','Delete Selected Response',...
   'callback',{@i_DeleteResponse,udh},...
   'position',[0 0 50 15]);
delGrd = xreggridlayout(figh,...
   'dimension',[1 2],...
   'elements',{ud.DelBtn,[]},...
   'correctalg','on',...
   'colsizes',[80 -1]);


els= {rtxt;ud.rlist; []; delGrd; []};
rsize= [15 -1 5 25 5 ];

m= HSModel(T.DesignDev);
if length(T.DesignDev)>1
   
   L= get(m,'Local');
   
   % twostage option layouts
   % the frame and controls for changing local and global models
   mtxt=uicontrol('style','text',...
      'parent',figh,...
      'horizontalalignment','left',...
      'string','Local model:',...
      'position',[0 0 80 15]);
   ud.localMod=uicontrol('style','text',...
      'parent',figh,...
      'horizontalalignment','left',...
      'string','',...
      'position',[0 0 100 20],...
      'interruptible','off',...
      'userdata',1);
   
   btn =uicontrol('style','push',...
      'parent',figh,...
      'horizontalalignment','left',...
      'string','Set Up...',...
      'position',[0 0 20 20],...
      'interruptible','off',...
      'userdata',1);
   
   
   gtxt=uicontrol('style','text',...
      'parent',figh,...
      'horizontalalignment','left',...
      'string','Global model:',...
      'position',[0 0 80 15]);
   ud.globalMod=uicontrol('style','text',...
      'parent',figh,...
      'horizontalalignment','left',...
      'string','',...
      'position',[0 0 100 20],...
      'interruptible','off',...
      'userdata',1);
   
   gbtn =uicontrol('style','push',...
      'parent',figh,...
      'horizontalalignment','left',...
      'string','Set Up...',...
      'position',[0 0 20 20],...
      'interruptible','off',...
      'userdata',1);
   
   
   
   
   dtmtxt=uicontrol('style','text',...
      'parent',figh,...
      'horizontalalignment','left',...
      'string','Datum:',...
      'position',[0 0 40 15]);
   ud.dtmpop=uicontrol('style','popupmenu',...
      'parent',figh,...
      'horizontalalignment','left',...
      'string',{'None','Maximum','Minimum','Link to R1 datum'},...
      'position',[0 0 100 20],...
      'backgroundcolor','w',...
      'interruptible','off',...
      'userdata',1);
   
   set(btn,'callback',{@i_setLocal,udh});
   set(gbtn,'callback',{@i_setGlobal,udh});
   set(ud.dtmpop,'callback',{@i_dtmmodel,udh});
   
   ud.SetBtns= [btn;gbtn;ud.dtmpop];
   
   
   flocal=xreggridlayout(figh,'dimension',[3 3],...
      'elements',{mtxt,ud.localMod,btn;
      dtmtxt,ud.dtmpop,[];
      gtxt,ud.globalMod,gbtn},...
      'correctalg','on',...
      'rowsizes',[20 20 20],...
      'colsizes',[70 100 60],...
      'gap',5);
   
   flocal= xregframetitlelayout(figh,...
      'title','Model',...
      'center',flocal);
   
   els= [els;{[];flocal}];
   rsize= [rsize 10 100];
   
else
   gtxt=uicontrol('style','text',...
      'parent',figh,...
      'horizontalalignment','left',...
      'string','Model:',...
      'position',[0 0 80 15]);
   ud.globalMod=uicontrol('style','text',...
      'parent',figh,...
      'horizontalalignment','left',...
      'string','',...
      'position',[0 0 100 20],...
      'interruptible','off',...
      'userdata',1);
   
   gbtn =uicontrol('style','push',...
      'parent',figh,...
      'horizontalalignment','left',...
      'string','...',...
      'position',[0 0 20 20],...
      'interruptible','off',...
      'userdata',1);
   
   fm=xreggridlayout(figh,'dimension',[1 3],...
      'elements',{gtxt,ud.globalMod,gbtn},...
      'correctalg','on',...
      'rowsizes',20,...
      'colsizes',[80 100 20],...
      'gapy',5);
   
   set(gbtn,'callback',{@i_setModel,udh});
   
   
   ud.SetBtns= gbtn;
   els= [els;{[];fm}];
   rsize= [rsize 10 20];
   
   
end
ud.gsetup= gbtn;

rlyt= xreggridlayout(figh,...
   'dimension',size(els),...
   'elements',els,...
   'correctalg','on',...
   'rowsizes',rsize);

% buttons between the lists match/add/delete
selbutton= xregGui.iconuicontrol('parent',figh,...
   'imageFile',[xregrespath,'\leftarrow.bmp'],...
   'transparentColor', [255 255 0],...
   'ToolTip','Match Data Variable to Response',...
   'callback',{@i_Select,udh});
abtn=uicontrol('style','pushbutton',...
   'parent',figh,...
   'string','<--  Add',...
   'tooltipstring','Add Data Variable as New Response',...
   'callback',{@i_AddResponse,udh},...
   'position',[0 0 50 15]);

blyt= xreggridlayout(figh,...
   'dimension',[4 1],...
   'elements',{[],selbutton,abtn,[]},...
   'correctalg','on',...
   'gapy',10,...
   'rowsizes',[10 80 25 -1]);
ud.SelBtn= selbutton;

lyt= xreggridlayout(figh,...
   'dimension',[1 3],...
   'elements',{rlyt,blyt,ylyt},...
   'correctalg','on',...
   'gapx',10,...
   'colsizes',[250 80 200]);


% initialise values
i_setvalues(ud);

set(ytxt,'userdata',ud);
return




%----------------------------------------------------
% SUBFUNCTION i_setvalues
%----------------------------------------------------
function i_setvalues(ud,sel)


T= ud.pointer.info;

if isempty(T.Responses) & numChildren(T)>0
   % pick up response models from children if there are none
   T.Responses= children(T,'model');
   for i=1:length(T.Responses)
      T.Responses{i}= reset(T.Responses{i});
   end
   xregpointer(T);
end

TestData=  T.DataLink.info;
VarNames= get(TestData,'name');
VarUnits= get(TestData,'name');

Xnames= factors(T);
% remove X variables
[VarNames,i]=setdiff(VarNames,Xnames);
VarUnits= VarUnits(i);
set(ud.ylist,'string',VarNames)


rlist= cell(1,length(T.Responses));

NotFnd=1;
for i=1:length(T.Responses)
   m= T.Responses{i};
   VarInd= find(strcmp(varname(m),VarNames));
   if isempty(VarInd)
      % can't find variable - choose one
      yi= yinfo(m);
      yi.Name = VarNames{NotFnd};
      yi.Units= VarUnits{NotFnd};
      m= yinfo(m,yi);
      T.Responses{i}= m;
      pointer(T);
      NotFnd= min(NotFnd+1,length(VarNames));
   end
   rlist{i}= ResponseLabel(m);
end


if nargin<2
   sel= min(1,length(T.Responses));
end
set(ud.rlist,'string',rlist,'value',sel);

if sel
   set(ud.DelBtn,'enable','on');
   set(ud.SetBtns,'enable','on');
   set(ud.SelBtn,'enable','on');	
   i_SelectModel(ud)
   
else
   % no responses disable set buttons
   set(ud.SetBtns,'enable','off');
   set(ud.DelBtn,'enable','off');
   set(ud.SelBtn,'enable','off');
   
end





function i_SelectModel(h,evt,udh);

if nargin==1
   ud = h;
else
   ud = get(udh,'userdata');
end


T= ud.pointer.info;
ind= get(ud.rlist,'value');
m= T.Responses{ind};

if isa(m,'xregtwostage');
   % set up string in Datum popupmenu
   DatumTypes= {'None','Maximum','Minimum','R1 datum'};
   if ind==1
      % can't have link to R1 for R1!
      DatumTypes=DatumTypes(1:end-1);
   elseif ~get(T.Responses{1},'datumtype')
      % No datum defined for R1 so can't have link;
      DatumTypes=DatumTypes(1:end-1);
   else
      DatumTypes{end}= sprintf('%s datum',varname(T.Responses{1}));
   end
   set(ud.dtmpop,'string',DatumTypes);
   % stages
   
   L= get(m,'local');
   % datum model
   if permitsDatum(L)
      set(ud.dtmpop,'enable','on');
   else
      set(L,'DatumType',0);
      set(ud.dtmpop,'value',1,'enable','off');
   end
   set(ud.localMod,'string',name(L))
   
   G= get(m,'global');
   isSame= 0;
   if ~isempty(G)
       n1= name(G{1});
       isSame= 1;
       for i=2:length(G)
           isSame= isSame & strcmp(n1,name(G{i}));
       end
       set(ud.gsetup,'enable','on')
   else
       set(ud.gsetup,'enable','off')
   end
   
   if isSame
       set(ud.globalMod,'string',n1)
   else
       set(ud.globalMod,'string','')
   end
   

   
   set(ud.dtmpop,'value',get(m,'DatumType')+1,'userdata',get(m,'DatumType')+1);
   
else
   set(ud.globalMod,'string',name(m))
end


VarInd= find(strcmp(varname(m),get(ud.ylist,'string')));
if ~isempty(VarInd)
   set(ud.ylist,...
      'ListBoxTop',max(1,VarInd-5),...
      'value',VarInd);
end


return


function i_dtmmodel(h,evt,udh)
ud = get(udh,'userdata');

T= ud.pointer.info;
ind= get(ud.rlist,'value');
m= T.Responses{ind};


newval=get(ud.dtmpop,'value');
oldval=get(ud.dtmpop,'userdata');
if newval==oldval
   return
end
set(ud.dtmpop,'userdata',newval);
DatumType = newval - 1;
switch DatumType
case {1,2}
   DatumModel = getModel(T.DesignDev(end));
case 3
   DatumModel = getModel(T.DesignDev(end));
otherwise
   DatumModel = 0;
end

L= get(m,'local');
if DatumType & ~(isa(L,'localpoly') | isa(L,'localpspline'))
   L= copymodel(L,localpoly);
end
if get(L,'DatumType') ~= DatumType
   set(L,'DatumType',DatumType);
   set(m,'Local',L);
   set(m,'Datum',DatumModel);
   if ind==1 & ~(DatumType==1 | DatumType==2)
      % change datumlink models
      for i=2:length(T.Responses)
         if get(T.Responses{i},'DatumType')==3
            L= get(T.Responses{i},'Local');
            set(L,'DatumType',0);
            T.Responses{i}= set(T.Responses{i},'Local',L);
         end
      end
   end
   
   % update testplan
   T.Responses{ind}= m;
   xregpointer(T);
end

return


function i_setLocal(h,evt,udh)
ud = get(udh,'userdata');

T= ud.pointer.info;
ind= get(ud.rlist,'value');
TS= T.Responses{ind};


OldModel= TS;

L= get(TS,'local');
GM= get(TS,'baseglobal');


XNames= factors(T);
xL= T.DataLink.info(:,XNames{1});

[L,OK]= gui_localmodsetup(L,'figure',isEquiSpaced(xL(:,1)),nfactors(L));
if OK
   set(TS,'Local',L);
   
   if any(strcmp(class(L),{'localpspline','localpoly'}))
      set(ud.dtmpop,'enable','on');
   else
      set(L,'DatumType',0);
      set(ud.dtmpop,'value',1,'enable','off');
   end
   
   
   set(ud.localMod,'string',name(L))
   if OK==3
      % get default global model from testplan
      GM = getModel(T.DesignDev(end));
      % model type or num response features have changed
      TS= xregtwostage(L,GM);
   end
   T.Responses{ind}= TS;
   xregpointer(T);
   if numfeats(L)>0
       set(ud.gsetup,'enable','on')
   else
       set(ud.gsetup,'enable','off')
   end

   
end





function i_setGlobal(h,evt,udh)

ud = get(udh,'userdata');

T= ud.pointer.info;
ind= get(ud.rlist,'value');
TS= T.Responses{ind};


L= get(TS,'local');
GM= get(TS,'baseglobal');

if ~isempty(GM)
    [m,OK]= gui_ModelSetup(GM);
    if OK
        TS= xregtwostage(L,m);
        T.Responses{ind}= TS;
        xregpointer(T);
        set(ud.globalMod,'string',name(m));
    end
end

function i_setModel(h,evt,udh)

ud = get(udh,'userdata');

T= ud.pointer.info;
ind= get(ud.rlist,'value');
m= T.Responses{ind};

[m,OK]= gui_ModelSetup(m);
if OK
   T.Responses{ind}= m;
   xregpointer(T);
   set(ud.globalMod,'string',name(m));
end


function i_Select(h,evt,udh)



ud = get(udh,'userdata');

T= ud.pointer.info;
ind= get(ud.rlist,'value');
m= T.Responses{ind};

yi= yinfo(m);


dlist= get(ud.ylist,'string');
dind= get(ud.ylist,'value');

varName= dlist{dind};

S= T.DataLink.info(:,varName);
un= get(S,'units');

yi.Name= varName;
yi.Units= un{1};
m= yinfo(m,yi);


rlist= get(ud.rlist,'string');
rlist{ind}= ResponseLabel(m);
set(ud.rlist,'string',rlist);

T.Responses{ind}= m;
xregpointer(T);


function i_AddResponse(h,evt,udh)

ud = get(udh,'userdata');

T= ud.pointer.info;

m= HSModel(T.DesignDev);
dlist= get(ud.ylist,'string');
dind= get(ud.ylist,'value');

varName= dlist{dind};

S= T.DataLink.info(:,varName);
un= get(S,'units');
yi= yinfo(m);
yi.Name= varName;
yi.Units= un{1};
m= yinfo(m,yi);

if isempty(T.Responses)
   T.Responses= {m};
else	
   T.Responses{end+1}= m;
end

xregpointer(T);

i_setvalues(ud,length(T.Responses));


function i_DeleteResponse(h,evt,udh)

ud = get(udh,'userdata');
ind= get(ud.rlist,'value');

T= ud.pointer.info;
m= T.Responses{ind};

if ind==1 & length(T.DesignDev)>1
   DatumType= get(m,'DatumType');
   if ~(DatumType==1 | DatumType==2)
      % change datumlink models
      for i=2:length(T.Responses)
         if get(T.Responses{i},'DatumType')==3
            L= get(T.Responses{i},'Local');
            set(L,'DatumType',0);
            T.Responses{i}= set(T.Responses{i},'Local',L);
         end
      end
   end
end

T.Responses(ind)= [];
xregpointer(T);

i_setvalues(ud);



