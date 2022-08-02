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


%   $Revision: 1.5.2.3 $  $Date: 2004/04/04 03:26:37 $


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
   'horizontalalignment','left');
ud.lhsszedt=xregGui.clickedit(figh,...
   'min',2,...
   'max',100000,...
   'visible','off',...
   'clickincrement',10,...
   'dragincrement',1,...
   'rule','int');
ud.mintxt=uicontrol('parent',figh,...
   'style','text',...
   'visible','off',...
   'horizontalalignment','left',...
   'position',[0 0 110 15]);
ud.maxtxt=uicontrol('parent',figh,...
   'style','text',...
   'visible','off',...
   'horizontalalignment','left');
ud.minedt=uicontrol('parent',figh,...
   'style','edit',...
   'backgroundcolor','w',...
   'visible','off',...
   'interruptible','off');
ud.maxedt=uicontrol('parent',figh,...
   'style','edit',...
   'backgroundcolor','w',...
   'visible','off',...
   'interruptible','off');
ud.selcrit=uicontrol('parent',figh,...
   'style','popupmenu',...
   'backgroundcolor','w',...
   'visible','off',...
   'string',{'Maximize minimum distance','Minimize maximum distance','Minimize discrepancy',...
      'Minimize RMS variation from CDF', 'Minimize maximum variation from CDF'});
selcrittxt=uicontrol('parent',figh,...
   'style','text',...
   'horizontalalignment','left',...
   'string','Selection criteria:',...
   'visible','off');
ud.symcheck=uicontrol('parent',figh,...
   'style','checkbox',...
   'string','Enforce symmetrical points',...
   'visible','off');

udh=ud.lstbox;
% callbacks
set(ud.lstbox,'callback',{@i_factchng,udh});
set(ud.minedt,'callback',{@i_minchng,udh});
set(ud.maxedt,'callback',{@i_maxchng,udh});
set(ud.lhsszedt,'callback',{@i_Nchng,udh});
set(ud.selcrit,'callback',{@i_critchng,udh});
set(ud.symcheck,'callback',{@i_symchng,udh});

lyt=xreggridbaglayout(figh,'dimension',[18  4],...
   'rowsizes',[3 15 2 10 4 15 1 10 20 10 3 15 2 5 3 15 2 -1],...
   'colsizes',[90 70 30 65],...
   'gapx',5,...
   'mergeblock',{[1 3],[2 2]},...
   'mergeblock',{[5 7],[2 4]},...
   'mergeblock',{[9 9],[1 2]},...
   'mergeblock',{[11 18],[1 1]},...
   'mergeblock',{[12 12],[2 3]},...
   'mergeblock',{[16 16],[2 3]},...
   'mergeblock',{[11 13],[4 4]},...
   'mergeblock',{[15 17],[4 4]},...
   'elements',{[], lhssztxt, [], [], [], selcrittxt, [], [], ud.symcheck, [], ud.lstbox, [], [], [], [], [], [], [], ...
      ud.lhsszedt, [], [], [], ud.selcrit, [], [], [], [], [], [], ud.mintxt, [], [], [], ud.maxtxt, [], [], ...
      [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], ...
      [], [], [], [], [], [], [], [], [], [], ud.minedt, [], [], [], ud.maxedt, [], [], []},...
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


function i_symchng(obj,nul,udh)
ud=get(udh,'userdata');
val=get(ud.symcheck,'value');
cs=ud.pointer.info;
if val~=get(cs,'symmetric')
   cs=set(cs,'symmetric',val);
   ud.pointer.info=cs;
   i_firecb(ud);
end
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
udh=get(lyt,'userdata');
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
      handle(ud.selcrit);ud.lhsszedt],'backgroundcolor',bgc,'enable',state);
set(ud.symcheck,'enable',state);
