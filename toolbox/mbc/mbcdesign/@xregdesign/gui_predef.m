function [dout,ok]=gui_predef(d,opt,varargin);
% GUI_PREDEF  GUIs for choosing pre-defined designs
%
%   [DOUT,OK]=GUI_PREDEF(D,OPT) invokes a dialog editing or
%   choosing a pre-defined design (classical/space-filling).
%   OPT may be a string/function handle for the constructor
%   of a candidateset.  In this case the user will be given
%   a dialog for editing the properties of the design.
%   OPT may also be a typecode - 1 for spacefilling, 2 for 
%   classical - in which case the user will be shown a dialog
%   with a drop-down menu for selecting a design type.
%
%   In both cases, if the input design already has points in
%   it then the user will be presented with a pre-dialog containing
%   options on whether to overwrite or replace the current design.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.6.2.4 $  $Date: 2004/04/04 03:27:11 $

if nargin<2
   error('Not enough input arguments');
end

% Decide which option to go for
if isnumeric(opt)
   if npoints(d)
      % do an add/overwrite dialog
      [sel,ok]=i_getop(d);
      if ~ok
         dout=d;
         return
      end
   else
      sel=1;
   end
   % want a list of all designs for this type
   scr=get(0,'screensize');
   if opt==1
      nm='Space-Filling Design Browser';
      htag='xreg_desSpaceFill';
   elseif opt==2
      nm='Classical Design Browser';
      htag='xreg_desClassical';
   else
      nm='Design Browser';
      htag='';
   end
   fHu=xregdialog('Name',nm,'position',[scr(3).*0.5-350 scr(4).*0.5-225  700 450],...
      'tag','DesignBrowser');
   fHu.MinimumSize=[600 380];
   xregpersistfigpos(fHu);
   xregmoveonscreen(fHu);
   fH=double(fHu);
   csI=csetinterface;
   csI=set(csI,'typefilter',opt);
   p=xregpointer([]);
   [lyt,GUI_STATE]=i_createlyt(fH,opt,p,d);
   set(lyt,'visible','on');
   % add ok, cancel
   if GUI_STATE
      EN_STATE='on';
   else
      EN_STATE='off';
   end
   okbtn=uicontrol('parent',fH,...
      'style','pushbutton',...
      'string','OK',...
      'position',[0 0 65 25],...
      'callback','set(gcbf,''tag'',''ok'',''visible'',''off'');',...
      'interruptible','off',...
      'enable',EN_STATE);
   cancbtn=uicontrol('parent',fH,...
      'style','pushbutton',...
      'string','Cancel',...
      'position',[0 0 65 25],...
      'callback','set(gcbf,''tag'',''cancel'',''visible'',''off'');',...
      'interruptible','off');
   helpbtn=mv_helpbutton(fH,htag,'position',[0 0 65 25]);
   
   fl=xregflowlayout(fH,'orientation','right/center',...
      'gap',7,...
      'border',[0 0 -7 0],...
      'packstatus','off',...
      'elements',{helpbtn,cancbtn,okbtn});
   mainlay=xreggridlayout(fH,...
      'correctalg','on',...
      'dimension',[2 1],...
      'elements',{lyt,fl},...
      'rowsizes',[-1 25],...
      'gap',10,...
      'border',[10 10 10 10]);   
   
   fHu.LayoutManager=mainlay;
   set(mainlay,'packstatus','on');
   fHu.showDialog(okbtn);
   
   tg=get(fH,'tag');
   if strcmp(tg,'ok')
      ok=1;
      i_finalise(lyt);
      cs=p.info;
   else
      ok=0;
   end
   freeptr(p);
   delete(fH);
   
else
   % string/fn handle.  Done mainly in candidateset/propedit
   % Take the default limits from current model?
   tgt=gettarget(model(d));
   prnt=candidateset(tgt);
   cs=feval(opt,prnt);
   [s,info]=getstyle(d);
   if (s==2 | s==3) & strcmp(class(info),class(cs))
      cs=info;
   end
   [fnm, nm,tp] = CandidateSetInformation(cs);
   
   if npoints(d)
      % do an add/overwrite dialog
      [sel,ok]=i_getop(d);
      if ~ok
         dout=d;
         return
      end
   else
      sel=1;
   end
   [nul,nul,tp]= CandidateSetInformation(cs);
   if tp==2
      helptag='xreg_desClassical';
   elseif tp==1
      helptag='xreg_desSpaceFill';
   else
      helptag='';
   end
   [cs,ok]=propedit(cs,'model',model(d),'help',helptag);
end

if ~ok
   dout=d;
   return
else
   switch sel
   case 1
      % edit new design
      action='replace';
   case 2
      % Add to design
      action='add';
   case 3
      % Overwrite only non-fixed points, keep fixed ones
      action='replacefree';
   end
   [nul,nul,tp]= CandidateSetInformation(cs);
   if tp==2
      [dout,rankok]= ClassicDesign(d,cs,action,'constrain');
   elseif tp==1
      [dout,rankok]= SpaceFillDesign(d,cs,action,'constrain');
   end
end
return






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function to popup a small figure to ask what to do with the potential new design points %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [out,ok]=i_getop(d)

scr=get(0,'screensize');
fig=xregdialog('name','Design Augment/Replace',...
   'position',[scr(3).*0.5-175 scr(4).*0.5-75 350 150],...
   'tag','cancel');
figh=double(fig);

txt=uicontrol('parent',figh,'style','text','enable','inactive',...
   'horizontalalignment','left',...
   'string','This design currently contains design points.  Do you want to:');
opts=xregGui.rbgroup(figh,'nx',1,'ny',3,'value',[1; 0; 0],'string',...
   {'Replace the current points with a new design';...
      'Augment the current design with additional points';...
      'Keep only the fixed points from the current design'});
okbtn=uicontrol('parent',figh,...
   'style','pushbutton',...
   'string','OK',...
   'position',[0 0 65 25],...
   'callback','set(gcbf,''tag'',''ok'',''visible'',''off'');',...
   'interruptible','off');
cancbtn=uicontrol('parent',figh,...
   'style','pushbutton',...
   'string','Cancel',...
   'position',[0 0 65 25],...
   'callback','set(gcbf,''tag'',''cancel'',''visible'',''off'');',...
   'interruptible','off');

fl=xregflowlayout(figh,'orientation','right/center',...
   'gap',7,...
   'border',[0 0 -7 0],...
   'packstatus','off',...
   'elements',{cancbtn,okbtn});

lyt=xreggridlayout(figh,'dimension',[3 1],'correctalg','on','rowsizes',[30 -1 45],...
   'elements',{txt,opts,fl},'packstatus','off','border',[10 0 10 10]);

fig.LayoutManager=lyt;
set(lyt,'packstatus','on');
fig.showDialog(okbtn);

tg=get(fig,'tag');
switch tg
case 'ok'
   out=get(opts,'selected');
   ok=1;
case 'cancel'
   out=0;
   ok=0;
end
delete(fig);
return


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function to create the browser GUI %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [lyt, GUI_STATE]=i_createlyt(fH, opt, p, d)
ud.pointer=p;
ud.figure=fH;
ud.model=model(d);
ud.modelnow=ud.model;
c=constraints(d);
if isempty(c)
   ud.constraints=[];
   ud.DoConstraints=0;
else
   ud.constraints=reset(c);   % keep this constraints object lightweight!
   ud.DoConstraints=1;
end
ud.design=d;
ud.closing=0;

% intialise candidateset object
csI=csetinterface;
csI=set(csI,'typefilter',opt);
csI=set(csI,'nffilter',nfactors(d));
viewlist=get(csI,'fullnames');
ud.createlist=get(csI,'classnames');
ud.cards=zeros(1,length(ud.createlist));

if length(viewlist)
   % available designs to choose from
   GUI_STATE=true;
   ENABLE_SETTING='on';
   ENABLE_SETTING_IN='inactive';
   [s,info]=getstyle(d);
   if opt==(s-1)
      % use the current settings as default
      ud.pointer.info=info;
      ind=strmatch(class(info),ud.createlist,'exact');
      if isempty(ind)
         ind=1;
      end
   else
      tgt=gettarget(ud.model);
      csP=candidateset(tgt);
      ud.pointer.info=feval(ud.createlist{1},csP);
      ind=1;
   end
else
   % no available designs
   GUI_STATE=false;
   ENABLE_SETTING='off';
   ENABLE_SETTING_IN='off';
   ind=1;  
   viewlist={''};
   ud.DoConstraints=0;
end

ud.typetxt=uicontrol('parent',fH,...
   'style','text',...
   'horizontalalignment','left',...
   'string','Design Style:',...
   'position',[0 0 70 15],...
   'enable',ENABLE_SETTING_IN);
ud.typepop=uicontrol('parent',fH,...
   'style','popupmenu',...
   'enable',ENABLE_SETTING,...
   'value',ind,...
   'string',viewlist,...
   'position',[0 0 150 20],...
   'interruptible','off',...
   'backgroundcolor','w');
ud.unitsopt=uicontrol('parent',fH,...
   'style','checkbox',...
   'string','View coded values',...
   'enable',ENABLE_SETTING,...
   'value',0);
ud.constcheck=uicontrol('parent',fH,...
   'style','checkbox',...
   'interruptible','off',...
   'string','Apply constraints to preview',...
   'enable',ENABLE_SETTING,...
   'value',1);
ud.npointstxt=uicontrol('parent',fH,...
   'style','text',...
   'interruptible','off',...
   'string','Number of design points:',...
   'enable',ENABLE_SETTING,...
   'horizontalalignment','left');
divl=xregGui.dividerline(fH);

sc=xregGui.SystemColorsDbl;
ud.gr1=mvgraph1d(fH);
set(ud.gr1,'backgroundcolor',sc.CTRL_BACK,'frame','off');
ud.gr2=mvgraph2d(fH);
set(ud.gr2,'backgroundcolor',sc.CTRL_BACK,'frame','off','factorselection','exclusive');
ud.gr3=mvgraph3d(fH);
set(ud.gr3,'backgroundcolor',sc.CTRL_BACK,'frame','off','factorselection','exclusive');
ud.gr4=mvgraph4d(fH);
set(ud.gr4,'backgroundcolor',sc.CTRL_BACK,'frame','off','factorselection','exclusive');


flw=xregflowlayout(fH,'elements',{ud.typetxt,ud.typepop},'gap',5,...
   'orientation','left/center','border',[-5 0 0 0],'packstatus','off');
if GUI_STATE
   proplyt=propertypage(p.info,'layout',fH,'callback',{@i_optschange,ud.typetxt});
   crd=xregcardlayout(fH,'numcards',1,'visible','off');
   attach(crd,proplyt,1);
else
   crd=uicontrol('parent',fH,...
      'visible','off',...
      'style','text',...
      'enable','inactive',...
      'horizontalalignment','left',...
      'string',['There are no design styles of this type available that are compatible with',...
         ' your current settings.  Please try a different type of design, or change the number',...
         ' of input factors in your experiment.']);
end
ud.cardlay=crd;
grd=xreggridlayout(fH,'correctalg','on','dimension',[2 1],...
   'rowsizes',[20 -1],'gap',10,'elements',{ud.unitsopt,crd});
left=xregframetitlelayout(fH,'visible','off','title','Options',...
   'center',grd);


ud.tabs=xregtablayout2(fH,'mintabsize',1,'buttonposition','bottom','numcards',4,...
   'tablabels',{'1-D','2-D','3-D','4-D'});
attach(ud.tabs,ud.gr1,1);
attach(ud.tabs,ud.gr2,2);
attach(ud.tabs,ud.gr3,3);
attach(ud.tabs,ud.gr4,4);
grd=xreggridlayout(fH,'correctalg','on','dimension',[4 1],...
   'rowsizes',[20 2 15 -1],'gap',10,...
   'elements',{ud.constcheck,divl,ud.npointstxt,ud.tabs});
right=xregframetitlelayout(fH,'title','Preview','center',grd);

grd=xreggridlayout(fH,'correctalg','on','dimension',[1 2],...
   'gap',10,'elements',{left,right});

lyt=xreggridlayout(fH,'correctalg','on','dimension',[2 1],...
   'rowsizes',[20 -1],'gap',10,'elements',{flw,grd});


udh=ud.typetxt;
set(ud.unitsopt,'callback',{@i_units,udh});
set(ud.typepop,'callback',{@i_typechange,udh});
set(ud.constcheck,'callback',{@i_constchange,udh});

if GUI_STATE
   ud.cards(ind)=1;
end
ud.GUI_STATE=GUI_STATE;

ud=i_setvalsinit(ud);
ud=i_setvalues(ud);
set(udh,'userdata',ud);
return


function ud=i_setvalsinit(ud)
% set values that only need to be decided once, on entry
if ud.DoConstraints
   set(ud.constcheck,'enable','on');
else
   set(ud.constcheck,'value',0,'enable','off');
end

if ~ud.GUI_STATE
   set(ud.tabs,'enable','off');
else
   nf=ud.pointer.nfactors;
   if nf<4
      en={'on','on','on','on'};
      en(nf+1:end)={'off'};
      set(ud.tabs,'enable',en);
   end
end
% initialise factor names in graph objects
if ud.GUI_STATE
   symb=get(ud.model,'symbol');
   ud.gr1.factors=symb;
   ud.gr2.factors=symb;
   ud.gr3.factors=symb;
   ud.gr4.factors=symb;
end
return


function ud=i_setvalues(ud,doapply);
if nargin<2
   doapply=1;
end
% check and create property page, update  property page, update preview
val=get(ud.typepop,'value');
if val>0 & ud.GUI_STATE
   if ~ud.cards(val)
      nc=get(ud.cardlay,'numcards');
      set(ud.cardlay,'numcards',nc+1);
      proplyt=propertypage(ud.pointer.info,'layout',ud.figure,'callback',{@i_optschange,ud.typetxt});
      attach(ud.cardlay,proplyt,nc+1);
      ud.cards(val)=nc+1;
   else
      proplyt=getcard(ud.cardlay,ud.cards(val));
      proplyt=proplyt{1};
   end
   % update propertypage
   propertypage(ud.pointer.info,'update',proplyt,ud.pointer,ud.modelnow);
   set(proplyt,'packstatus','on');
   set(ud.cardlay,'currentcard',ud.cards(val));
end

% update preview
if doapply & ud.GUI_STATE
   proplyt=getcard(ud.cardlay);
   propertypage(ud.pointer.info,'quickapply',proplyt{1});
end
if ud.GUI_STATE
   ud=i_setpreview(ud);
end
return


function ud=i_setpreview(ud)
% get design points
data=fullset(ud.pointer.info);
lims=limits(ud.pointer.info);
if get(ud.constcheck,'value')
   % apply constraints to points
   [c,in]=eval(ud.constraints,data);
   data=data(in,:);
end
if ~isempty(data)
    % check data isn't outside limits and adjust limits if necessary - CCD designs do this
    lims(:,1)=min(lims(:,1),min(data,[],1)');
    lims(:,2)=max(lims(:,2),max(data,[],1)');
end

% invcode data
data=invcode(ud.modelnow,data);
lims=num2cell(invcode(ud.modelnow,lims')',2);
np=size(data,1);

set(ud.npointstxt,'string',sprintf('Number of points in preview design: %d',np));
nf=size(data,2);
set(ud.gr1,'data',data,'limits',lims);
if nf>1
   set(ud.gr2,'data',data,'limits',lims);
   if nf>2
      set(ud.gr3,'data',data,'limits',lims);
      if nf>3
         set(ud.gr4,'data',data,'limits',lims);
      end
   end
end
return



function i_finalise(lyt)
% finalise the cset selection.
% get handle to ud
udh=lyt2udh(lyt);
ud=get(udh,'userdata');
crd=getcard(ud.cardlay);
% turn off callback updating
ud.closing=1;
set(udh,'userdata',ud);
propertypage(ud.pointer.info,'finalise',crd{1});
return



function h=lyt2udh(lyt)
% return udh for a lyt
el=get(lyt,'elements');        
el=get(el{1},'elements');       
h=el{1};
return



%%%%%%%%%%%%%
% Callbacks %
%%%%%%%%%%%%%
function i_units(obj,nul,udh)
ud=get(udh,'userdata');
if get(ud.unitsopt,'value');
   % coded - set model limits to be same as target limits
   m=ud.model;
   [bnds,g,tgt]=getcode(m);
   ud.modelnow=setcode(m,tgt,g,tgt);
else
   % natural
   ud.modelnow=ud.model;
end
ud=i_setvalues(ud,0);
set(udh,'userdata',ud);
return


function i_typechange(obj,nul,udh)
ud=get(udh,'userdata');
val=get(ud.typepop,'value');
if ud.cards(val)~=get(ud.cardlay,'currentcard')
   ud.pointer.info=feval(ud.createlist{val},toCandidateSet(ud.pointer.info));
   ud=i_setvalues(ud);
   set(udh,'userdata',ud);
end
return


function i_optschange(proplyt,nul,udh)
ud=get(udh,'userdata');
if ~ud.closing
   proplyt=getcard(ud.cardlay);
   propertypage(ud.pointer.info,'quickapply',proplyt{1});
   ud=i_setpreview(ud);
   set(udh,'userdata',ud);
end
return

function i_constchange(proplyt,nul,udh)
ud=get(udh,'userdata');
ud=i_setpreview(ud);
set(udh,'userdata',ud);
return


