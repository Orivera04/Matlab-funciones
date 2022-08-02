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


%   $Revision: 1.6.2.2 $  $Date: 2004/02/09 07:02:01 $



switch lower(action)
case 'layout'
   out=i_createlyt(varargin{:});
case 'update'
   out=i_update(varargin{:});
case 'finalise'
   out=i_finalise(varargin{:});
case 'quickapply'
   % do a quick finalise
   out=i_quickapply(varargin{:});
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
ud.enable=1;
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
   'style','listbox');
lhssztxt=uicontrol('parent',figh,...
   'style','text',...
   'visible','off',...
   'string','Number of points:',...
   'position',[0 0 90 15],...
   'horizontalalignment','left');
ud.lhsszedt=xregGui.clickedit(figh,...
   'min',2,...
   'max',100000,...
   'visible','off',...
   'clickincrement',10,...
   'dragincrement',1,...
   'rule','int',...
   'position',[0 0 70 20]);
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
ud.selcrit=uicontrol('parent',figh,...
   'style','popupmenu',...
   'backgroundcolor','w',...
   'visible','off',...
   'position',[0 0 180 20],...
   'string',{'Maximize minimum distance','Minimize maximum distance','Minimize discrepancy',...
      'Minimize RMS variation from CDF', 'Minimize maximum variation from CDF'});
selcrittxt=uicontrol('parent',figh,...
   'style','text',...
   'horizontalalignment','left',...
   'string','Selection criteria:',...
   'position',[0 0 90 15]);

ud.dostratify=uicontrol('parent',figh,...
   'style','checkbox',...
   'string','Stratify levels for X',...
   'interruptible','off',...
   'visible','off');
ud.strattxt=uicontrol('parent',figh,...
   'style','text',...
   'visible','off',...
   'horizontalalignment','left',...
   'position',[0 0 120 15]);
ud.stratedt=xregGui.clickedit(figh,...
   'min',2,...
   'max',100,...
   'visible','off',...
   'clickincrement',1,...
   'dragincrement',1,...
   'rule','int',...
   'position',[0 0 70 20]);

udh=ud.lstbox;
% callbacks
set(ud.lstbox,'callback',{@i_factchng,udh});
set(ud.minedt,'callback',{@i_minchng,udh});
set(ud.maxedt,'callback',{@i_maxchng,udh});
set(ud.lhsszedt,'callback',{@i_Nchng,udh});
set(ud.selcrit,'callback',{@i_critchng,udh});
set(ud.dostratify,'callback',{@i_stratchng,udh});
set(ud.stratedt,'callback',{@i_stratchng,udh});

flw1=xregflowlayout(figh,'orientation','left/center','gap',10,...
   'border',[-10 0 0 0],'elements',{ud.mintxt,ud.minedt},...
   'packstatus','off');
flw2=xregflowlayout(figh,'orientation','left/center','gap',10,...
   'border',[-10 0 0 0],'elements',{ud.maxtxt,ud.maxedt});
flw3=xregflowlayout(figh,'orientation','left/center','gap',10,...
   'border',[-10 0 0 0],'elements',{ud.strattxt,ud.stratedt});
grd=xreggridlayout(figh,'correctalg','on','dimension',[2 1],...
   'elements',{ud.dostratify,flw3});
frm=xregframetitlelayout(figh,'title','Stratification',...
   'center',grd);
grd=xreggridlayout(figh,'dimension',[3 1],'correctalg','on','gapy',5,...
   'elements',{flw1,flw2,frm},'rowsizes',[20 20,80]);
flwtop1=xregflowlayout(figh,'orientation','left/center','gap',5,'border',[-5 10 0 0],...
   'elements',{lhssztxt,ud.lhsszedt});
flwtop2=xregflowlayout(figh,'orientation','left/center','gap',5,'border',[-5 10 0 0],...
   'elements',{selcrittxt,ud.selcrit});

spl=xregsplitlayout(figh,...
   'left',ud.lstbox,...
   'right',grd,...
   'split',[.25 .75],...
   'leftinnerborder',[0 5 0 0],...
   'rightinnerborder',[0 0 0 5],...
   'resizable','off');
lyt=xreggridlayout(figh,...
   'correctalg','on',...
   'dimension',[3 1],...
   'rowsizes',[30 30 -1],...
   'elements',{flwtop1, flwtop2, spl},...
   'userdata',udh);

ud.layout=lyt;
set(udh,'userdata',ud);
return



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% External update function.  Finds udh the dirty way %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function lyt=i_update(lyt,p,m)
% update current layout
udh=i_lyt2udh(lyt);
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

% disable auto-updating on cset
cs=set(cs,'dorecalc',0);
ud.pointer.info=cs;

set([ud.mintxt;ud.maxtxt],{'string'},...
   {['Minimum ' fact ' value:'];['Maximum ' fact ' value:']});

lims=get(cs,'limits');
lims=invcode(ud.model,lims{factnum}',factnum);
set([ud.minedt;ud.maxedt],{'string'},...
   {lims(1);lims(2)});

set(ud.lhsszedt,'value',get(cs,'n'));

str= get(cs,'costmethod');
val=strmatch(str,{'maximin','minimax','discrepancy','cdfvariance','cdfmaximum'},'exact');
set(ud.selcrit,'value',val);

% stratification
strat=get(cs,'stratifylevels');
set(ud.dostratify,'string',['Stratify levels for ' fact]);
if strat(factnum)
   set(ud.dostratify,'value',1);
   set(ud.stratedt,'value',strat(factnum),'max',get(cs,'n'));
   set(ud.strattxt,'string',['Number of levels for ' fact ':'],'enable','on');
   if ud.enable
      set(ud.stratedt,'enable','on');
   end
else
   set(ud.dostratify,'value',0);
   set(ud.stratedt,'value',5,'max',get(cs,'n'),'enable','off');
   set(ud.strattxt,'string',['Number of levels for ' fact ':'],'enable','off');
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



function i_Nchng(obj,nul,udh)
ud=get(udh,'userdata');
val=get(ud.lhsszedt,'value');
cs=set(ud.pointer.info,'N',val);
ud.pointer.info=cs;
set(udh,'userdata',ud);

nlvl=get(ud.stratedt,'value');
set(ud.stratedt,'max',val);
if val<nlvl
   % need to note new change in number of strat levels
   i_stratchng(ud.stratedt,nul,udh);
end
i_firecb(ud);
return


function i_critchng(obj,nul,udh)
ud=get(udh,'userdata');
val=get(ud.selcrit,'value');
strs={'maximin','minimax','discrepancy','cdfvariance','cdfmaximum'};
cs=set(ud.pointer.info,'costmethod',strs{val});
ud.pointer.info=cs;
set(udh,'userdata',ud);
i_firecb(ud);
return



function i_stratchng(obj,nul,udh)
ud=get(udh,'userdata');
factnum=get(ud.lstbox,'value');
cs=ud.pointer.info;
strat=get(cs,'stratifylevels');
newval=get(ud.dostratify,'value');
if newval
   strat(factnum)=get(ud.stratedt,'value');
   set(ud.strattxt,'enable','on');
   set(ud.stratedt,'enable','on');
else
   strat(factnum)=0;  
   set(ud.strattxt,'enable','off');
   set(ud.stratedt,'enable','off');
end
cs=set(cs,'stratifylevels',strat);
ud.pointer.info=cs;
i_firecb(ud);
return



function lyt=i_finalise(lyt)
udh=i_lyt2udh(lyt);
ud=get(udh,'userdata');
cs=ud.pointer.info;
sg=get(cs,'showgui');
cs=set(cs,'showgui',1);
cs=set(cs,'dorecalc',1);
cs=set(cs,'showgui',sg);
ud.pointer.info=cs;
i_firecb(ud);
return


function lyt=i_quickapply(lyt)
udh=i_lyt2udh(lyt);
ud=get(udh,'userdata');
cs=ud.pointer.info;
sg=get(cs,'showgui');
cs=set(cs,'showgui',1);
cs=set(cs,'doquickrecalc',50);
cs=set(cs,'showgui',sg);
cs=set(cs,'dorecalc',0);
ud.pointer.info=cs;
return


function udh=i_lyt2udh(lyt)
el=get(lyt,'elements');
udh=get(el{3},'left');
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
set([handle(ud.minedt);handle(ud.maxedt);handle(ud.dostratify);...
      handle(ud.selcrit);ud.lhsszedt;ud.stratedt],'backgroundcolor',bgc,'enable',state);
set(udh,'userdata',ud);