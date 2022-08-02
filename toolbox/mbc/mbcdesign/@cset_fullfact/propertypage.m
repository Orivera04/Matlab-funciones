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


%   $Revision: 1.5.2.2 $  $Date: 2004/02/09 07:00:27 $

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
   'min',0,...
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

ud.nlvledt=xregGui.clickedit(figh,...
   'min',2,...
   'visible','off',...
   'clickincrement',1,...
   'dragincrement',.1,...
   'rule','int');
ud.nlvltxt=xregGui.labelcontrol('parent',figh,...
   'visible','off',...
   'LabelSizeMode','absolute',...
   'LabelSize',115,...
   'ControlSizeMode','absolute',...
   'ControlSize',70,...
   'gap',5,...
   'string','',...
   'Control',ud.nlvledt);


udh=ud.lstbox;
% callbacks
set(ud.lstbox,'callback',{@i_factchng,udh});
set(ud.minedt,'callback',{@i_minchng,udh});
set(ud.maxedt,'callback',{@i_maxchng,udh});
set(ud.cpedt,'callback',{@i_cpchng,udh});
set(ud.nlvledt,'callback',{@i_nlevels,udh});

lyt=xreggridbaglayout(figh,...
   'packstatus','off',...
   'dimension',[5 2],...
   'rowsizes',[20 20 20 20 -1],...
   'colsizes',[70 -1],...
   'gapx',10,...
   'gapy',5,...
   'mergeblock',{[2 5],[1 1]},...
   'mergeblock',{[1 1],[1 2]},...
   'elements',{ud.cptxt,ud.lstbox,[],[],[],...
      [],ud.mintxt,ud.maxtxt,ud.nlvltxt,[]},...
   'userdata',udh);

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
set([ud.mintxt;ud.maxtxt;ud.nlvltxt],{'string'},...
   {['Minimum ' fact ' value:'];['Maximum ' fact ' value:'];['Number of levels for ' fact ':']});

lims=get(cs,'limits');
lims=invcode(ud.model,lims{factnum}',factnum);
set([ud.minedt;ud.maxedt],{'string'},...
   {lims(1);lims(2)});

set(ud.cpedt,'value',get(cs,'numcenter'));

nl=get(cs,'nlevels');
set(ud.nlvledt,'value',nl(factnum),'max',min(100,floor(1e6^(1/nf))));
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



function i_firecb(ud)
xregcallback(ud.callback,ud.layout,[]);
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
set([ud.cpedt;handle(ud.minedt);handle(ud.maxedt);ud.nlvledt],'backgroundcolor',bgc,'enable',state);
set(udh,'userdata',ud);




function i_nlevels(obj,nul,udh)
ud=get(udh,'userdata');
nl=get(ud.pointer.info,'nlevels');
factnum=get(ud.lstbox,'value');
nl(factnum)=get(ud.nlvledt,'value');
ud.pointer.info=set(ud.pointer.info,'nlevels',nl);
i_firecb(ud);
return