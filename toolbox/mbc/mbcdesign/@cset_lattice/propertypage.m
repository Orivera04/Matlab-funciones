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


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:01:06 $


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

ud.lstbox=xreguicontrol('parent',figh,...
   'visible','off',...
   'backgroundcolor','w',...
   'value',1,...
   'style','listbox');
lattsztxt=xreguicontrol('parent',figh,...
   'style','text',...
   'visible','off',...
   'string','Lattice size:',...
   'position',[0 0 70 15],...
   'horizontalalignment','left');
ud.lattszedt=xregGui.clickedit(figh,...
   'min',2,...
   'max',1e6,...
   'visible','off',...
   'clickincrement',10,...
   'dragincrement',1,...
   'rule','int',...
   'position',[0 0 70 20]);
ud.mintxt=xreguicontrol('parent',figh,...
   'style','text',...
   'visible','off',...
   'horizontalalignment','left',...
   'position',[0 0 110 15]);
ud.maxtxt=xreguicontrol('parent',figh,...
   'style','text',...
   'visible','off',...
   'horizontalalignment','left',...
   'position',[0 0 110 15]);
ud.minedt=xreguicontrol('parent',figh,...
   'style','edit',...
   'backgroundcolor','w',...
   'visible','off',...
   'position',[0 0 70 20],...
   'interruptible','off');
ud.maxedt=xreguicontrol('parent',figh,...
   'style','edit',...
   'backgroundcolor','w',...
   'visible','off',...
   'position',[0 0 70 20],...
   'interruptible','off');
ud.gtxt=xreguicontrol('parent',figh,...
   'style','text',...
   'visible','off',...
   'horizontalalignment','left',...
   'position',[0 0 110 15]);
ud.gedt=xregGui.clickedit(figh,...
   'min',2,...
   'visible','off',...
   'rule','prime',...
   'position',[0 0 70 20]);

udh=ud.lstbox;
% callbacks
set(ud.lstbox,'callback',{@i_factchng,udh});
set(ud.minedt,'callback',{@i_minchng,udh});
set(ud.maxedt,'callback',{@i_maxchng,udh});
set(ud.gedt,'callback',{@i_gchng,udh});
set(ud.lattszedt,'callback',{@i_Nchng,udh});

flw1=xregflowlayout(figh,'orientation','left/center','gap',10,...
   'border',[-10 0 0 0],'elements',{ud.mintxt,ud.minedt},...
   'packstatus','off');
flw2=xregflowlayout(figh,'orientation','left/center','gap',10,...
   'border',[-10 0 0 0],'elements',{ud.maxtxt,ud.maxedt});
flw3=xregflowlayout(figh,'orientation','left/center','gap',10,...
   'border',[-10 0 0 0],'elements',{ud.gtxt,ud.gedt});
grd=xreggridlayout(figh,'dimension',[3 1],'correctalg','on','gapy',5,...
   'elements',{flw1,flw2,flw3},'rowsizes',[20 20 20]);
flwbtm=xregflowlayout(figh,'orientation','left/center','gap',5,'border',[-5 10 0 0],...
   'elements',{lattsztxt,ud.lattszedt});
spl=xregsplitlayout(figh,...
   'left',ud.lstbox,...
   'right',grd,...
   'split',[.25 .75],...
   'leftinnerborder',[0 5 0 0],...
   'rightinnerborder',[0 0 0 5],...
   'resizable','off');
lyt=xreggridlayout(figh,...
   'correctalg','on',...
   'dimension',[2 1],...
   'rowsizes',[30 -1],...
   'elements',{flwbtm,spl},...
   'userdata',udh);

ud.layout=lyt;
set(udh,'userdata',ud);
return



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% External update function.  Finds udh the dirty way %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function lyt=i_update(lyt,p,m)
% update current layout
el=get(lyt,'elements');
el=get(el{2},'left');
ud=get(el,'userdata');
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
set([ud.mintxt;ud.maxtxt;ud.gtxt],{'string'},...
   {['Minimum ' fact ' value:'];['Maximum ' fact ' value:'];['Prime number for ' fact ':']});

lims=get(cs,'limits');
lims=invcode(ud.model,lims{factnum}',factnum);
set([ud.minedt;ud.maxedt],{'string'},...
   {lims(1);lims(2)});

set(ud.lattszedt,'value',get(cs,'n'));
maxg=primes(get(cs,'n'));
maxg=maxg(end);
g=get(cs,'g');
set(ud.gedt,'value',g(factnum),'max',maxg);
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



function i_Nchng(obj,nul,udh)
ud=get(udh,'userdata');
val=get(ud.lattszedt,'value');
cs=set(ud.pointer.info,'N',val);
p=primes(val);
p=p(end);
set(ud.gedt,'max',p);
% check the g values are all below Nmax
g=get(cs,'g');
if any(g>p)
   % uh-oh
   g(g>p)=p;
   cs=set(cs,'g',g);
   factnum=get(ud.lstbox,'value');
   set(ud.gedt,'value',g(factnum));
end
ud.pointer.info=cs;
set(udh,'userdata',ud);
i_firecb(ud);
return



function i_gchng(obj,nul,udh)
ud=get(udh,'userdata');
factnum=get(ud.lstbox,'value');
g=get(ud.pointer.info,'g');
oldval=g(factnum);
p=get(ud.gedt,'value');
g(factnum)=p;
cs=set(ud.pointer.info,'g',g);
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
else
   bgc=sc.CTRL_BACK;
end
set([handle(ud.minedt);handle(ud.maxedt);...
      handle(ud.gedt);ud.lattszedt],'backgroundcolor',bgc,'enable',state);
