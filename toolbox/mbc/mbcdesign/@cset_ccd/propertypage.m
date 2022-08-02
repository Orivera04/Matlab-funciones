function out=propertypage(obj,action,varargin);
% PROPERTYPAGE  Create a property gui for CandidateSet
%
%
%   This should be overloaded by child classes
%
%   Interface:  Lyt=propertypage(cs,'layout',fig);
%               Lyt=propertypage(cs,'update',lyt,p_cs,model);
%               Lyt=propertypage(cs,'enable',lyt,enstate);


%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 07:00:16 $

switch lower(action)
case 'layout'
   out=i_createlyt(varargin{:});
case 'update'
   out=i_update(varargin{:});
case 'enable'
   out=i_setenable(varargin{:});
end
return




function lyt=i_createlyt(figh,varargin)

% create new layout in figure
ud.pointer=[];
ud.figure=figh;
ud.model=[];
ud.callback='';
if nargin>1
   for n=1:2:length(varargin)
      switch lower(varargin{n})
      case 'callback'
         ud.callback=varargin{n+1};
      end
   end
end
ud.enable=1;

ud.lstbox=uicontrol('parent',figh,...
   'visible','off',...
   'backgroundcolor','w',...
   'value',1,...
   'style','listbox');

ud.cpedt=xregGui.clickedit(figh,...
   'min',1,...
   'max',20,...
   'visible','off',...
   'clickincrement',1,...
   'dragincrement',1,...
   'rule','int');
ud.cptxt=xregGui.labelcontrol('parent',figh,...
   'visible','off',...
   'LabelSizeMode','absolute',...
   'LabelSize',120,...
   'ControlSizeMode','absolute',...
   'ControlSize',70,...
   'gap',5,...
   'string','Number of center points:',...
   'Control',ud.cpedt);

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
ud.mintxt=xregGui.labelcontrol('parent',figh,...
   'visible','off',...
   'LabelSizeMode','absolute',...
   'LabelSize',115,...
   'ControlSizeMode','absolute',...
   'ControlSize',70,...
   'gap',5,...
   'string','',...
   'Control',ud.minedt);
ud.maxtxt=xregGui.labelcontrol('parent',figh,...
   'visible','off',...
   'LabelSizeMode','absolute',...
   'LabelSize',115,...
   'ControlSizeMode','absolute',...
   'ControlSize',70,...
   'gap',5,...
   'string','',...
   'Control',ud.maxedt);

ud.aopts=xregGui.rbgroup(figh,...
   'visible','off',...
   'nx',1,'ny',4,...
   'value',[1; 0; 0; 0],...
   'string',{'Face center cube';'Spherical';'Rotatable';'Custom'});

ud.aedt=xregGui.clickedit('parent',figh,...
   'min',1,...
   'visible','off',...
   'clickincrement',.1,...
   'dragincrement',.05,...
   'position',[0 0 60 20]);
ud.atxt=xregGui.labelcontrol('parent',figh,...
   'visible','off',...
   'LabelSizeMode','absolute',...
   'LabelSize',115,...
   'ControlSizeMode','absolute',...
   'ControlSize',70,...
   'gap',5,...
   'string','',...
   'Control',ud.aedt);

ud.inscribe=xregGui.uicontrol('parent',figh,...
   'style','checkbox',...
   'string','Inscribe star points',...
   'visible','off');

udh=ud.lstbox;
% callbacks
set(ud.lstbox,'callback',{@i_factchng,udh});
set(ud.minedt,'callback',{@i_minchng,udh});
set(ud.maxedt,'callback',{@i_maxchng,udh});
set(ud.aedt,'callback',{@i_achng,udh});
set(ud.cpedt,'callback',{@i_cpchng,udh});
set(ud.aopts,'callback',{@i_aopts,udh});
set(ud.inscribe,'callback',{@i_setinscr,udh});

grd0=xreggridlayout(figh,'correctalg','on',...
   'dimension',[3 1],...
   'rowsizes',[80 20 -1],...
   'gap',5,...
   'elements',{ud.aopts,ud.atxt,[]});
alay=xregframetitlelayout(figh,'visible','off','title','Star Point Position','center',grd0);
lyt=xreggridbaglayout(figh,...
   'dimension',[6 2],...
   'rowsizes',[20 20 20 130 20 -1],...
   'colsizes',[70 -1],...
   'gapx',10,...
   'gapy',5,...
   'mergeblock',{[2 6],[1 1]},...
   'mergeblock',{[1 1],[1 2]},...
   'elements',{ud.cptxt,ud.lstbox,[],[],[],[],...
      [],ud.mintxt,ud.maxtxt,alay,ud.inscribe,[]},...
   'userdata',udh);

ud.cust_a=ud.atxt;
ud.layout=lyt;
set(udh,'userdata',ud);
return



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% External update function.  Finds udh the dirty way %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function lyt=i_update(lyt,p,m)
% update current layout
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
nf=length(fact);
set(ud.lstbox,'string',fact);

factnum=get(ud.lstbox,'value');
fact=fact{factnum};
cs=ud.pointer.info;
set([ud.mintxt;ud.maxtxt;ud.atxt],{'string'},...
   {['Minimum ' fact ' value:'];['Maximum ' fact ' value:'];['Alpha ratio for ' fact ':']});

lims=get(cs,'limits');
lims=invcode(ud.model,lims{factnum}',factnum);
set([ud.minedt;ud.maxedt],{'string'},...
   {lims(1);lims(2)});

set(ud.cpedt,'value',get(cs,'numcenter'));

a=get(cs,'alpha');
set(ud.aedt,'value',a(factnum));
% look for face center, spherical
if all(a==1)
   set(ud.aopts,'selected',1);
   set(ud.cust_a,'enable','off');
elseif all(abs(a-sqrt(nf))<1e-10)
   set(ud.aopts,'selected',2);
   set(ud.cust_a,'enable','off');
elseif all(abs(a-(2^(nf/4)))<1e-10)
   set(ud.aopts,'selected',3);    % rotatable if a= 2^(nf/4)
   set(ud.cust_a,'enable','off');
else
   set(ud.aopts,'selected',4);
   if ud.enable
      set(ud.cust_a,'enable','on');
   end
end

in=get(cs,'inscribe');
if strcmp(in,'on')
   set(ud.inscribe,'value',1);
else
   set(ud.inscribe,'value',0);
end
return


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Callbacks from each object %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function i_factchng(obj,nul,udh)
ud=get(udh,'userdata');
ud=i_setvalues(ud);
set(udh,'userdata',ud);
return



function i_minchng(obj,nul,udh)
ud=get(udh,'userdata');
factnum=get(ud.lstbox,'value');
mnval=str2double(get(ud.minedt,'string'));
mnval=code(ud.model,mnval,factnum);
cs=ud.pointer.info;
lims=get(cs,'limits');
mxval=lims{factnum}(2);
if isempty(mnval) | length(mnval)~=1 | mnval>=mxval | isnan(mnval)
   % reset display
   lims=invcode(ud.model,lims{factnum}(:),factnum);
   set(ud.minedt,'string',min(lims));
else
   lims{factnum}(1)=mnval;
   cs=set(cs,'limits',lims);
   ud.pointer.info=cs;
   set(udh,'userdata',ud);
   i_firecb(ud);
end
return



function i_maxchng(obj,nul,udh)
ud=get(udh,'userdata');
factnum=get(ud.lstbox,'value');
mxval=str2double(get(ud.maxedt,'string'));
mxval=code(ud.model,mxval,factnum);
cs=ud.pointer.info;
lims=get(cs,'limits');
mnval=lims{factnum}(1);
if isempty(mxval) | length(mxval)~=1 | mnval>=mxval | isnan(mxval)
   % reset display
   lims=invcode(ud.model,lims{factnum}(:),factnum);
   set(ud.maxedt,'string',max(lims));
else
   lims{factnum}(2)=mxval;
   cs=set(cs,'limits',lims);
   ud.pointer.info=cs;
   set(udh,'userdata',ud);
   i_firecb(ud);
end
return



function i_cpchng(obj,nul,udh)
ud=get(udh,'userdata');
val=get(ud.cpedt,'value');
cs=set(ud.pointer.info,'numcenter',val);
ud.pointer.info=cs;
set(udh,'userdata',ud);
i_firecb(ud);
return



function i_achng(obj,nul,udh)
ud=get(udh,'userdata');
factnum=get(ud.lstbox,'value');
val=get(ud.aedt,'value');
cs=ud.pointer.info;
a=get(cs,'alpha');
a(factnum)=val;
cs=set(cs,'alpha',a);
ud.pointer.info=cs;
set(udh,'userdata',ud);
i_firecb(ud);
return


function i_aopts(obj,nul,udh)
ud=get(udh,'userdata');

sel=get(obj,'selected');
if sel==4
   set(ud.cust_a,'enable','on');
else
   if sel==1
      val=1;
   elseif sel==2
      val=sqrt(nfactors(ud.pointer.info));
   elseif sel==3
      val=2^(nfactors(ud.pointer.info)/4);
   end
   set(ud.cust_a,'enable','off');
   set(ud.aedt,'value',val);
   % set alpha into cs
   cs=ud.pointer.info;
   a=get(cs,'alpha');
   a(:)=val;
   cs=set(cs,'alpha',a);
   ud.pointer.info=cs;
end
i_firecb(ud);
return

function i_firecb(ud)
xregcallback(ud.callback,ud.layout,[]);
return


function i_setinscr(obj,nul,udh)
ud=get(udh,'userdata');
cs=ud.pointer.info;
sel=get(obj,'value');
if sel
   cs=set(cs,'inscribe','on');
else
   cs=set(cs,'inscribe','off');
end
ud.pointer.info=cs;
i_firecb(ud);
return


function lyt=i_setenable(lyt,state)
udh=get(lyt,'userdata');
ud=get(udh,'userdata');
sc=xregGui.SystemColorsDbl;
if strcmp(state,'on')
   bgc=[1 1 1];
   ud.enable=1;
else
   bgc=sc.CTRL_BACK;
   ud.enable=0;
end
set(ud.aopts,'enable',state);
set([ud.cpedt;handle(ud.minedt);handle(ud.maxedt);ud.aedt],'backgroundcolor',bgc,'enable',state);
set(udh,'userdata',ud);