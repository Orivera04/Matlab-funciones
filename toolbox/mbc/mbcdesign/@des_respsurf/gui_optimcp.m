function [dout,ok]=gui_optimcp(d,action,figh,p,varargin);
% GUI_OPTIMCP Optimisation control panel
%
%   [D,OK]=GUI_OPTIMCP(D) creates a dialog containing both
%   the optimisation settings and the optimise gui - a 
%   complete optimisation control panel.
%   OK == 0  ==> cancel
%   OK == 1  ==> ok, but no optimisation done
%   OK == 2  ==> ok, and optimisation has been done
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 07:03:40 $


if nargin<2
   action='figure';
end


switch lower(action)
case 'figure'
   [dout,ok]=i_createfig(d);
case 'layout'
   dout=i_createlyt(figh,p,varargin{:});
   ok=1;
end
return


function [dout,ok]=i_createfig(d)

% can only optimise a rank-checked design
if ~rankcheck(d)
   h=errordlg(['This design has not been initialised with enough points.',...
         '  You must reinitialize it before optimizing.'],'Error');
   dout=d;
   ok=0;
   return
end

sc=get(0,'screensize');
figh=figure('position',[sc(3)/2-330 sc(4)/2-220 660 425],...
   'tag','OptimiseCP',...
   'visible','off',...
   'units','pixels',...
   'toolbar','none',...
   'menubar','none',...
   'numbertitle','off',...
   'name','Design Optimization',...
   'resize','off',...
   'doublebuffer','on',...
   'closerequestfcn','set(gcbf,''tag'',''cancel'');',...
   'color',get(0,'defaultuicontrolbackgroundcolor'));


p=xregpointer(d);
lyt=i_createlyt(figh,p);
set(lyt,'visible','on');

% set up position control buttons
ud.cancbtn=uicontrol('parent',figh,...
   'style','pushbutton',...
   'position',[316 7 65 25],...
   'string','Cancel',...
   'userdata',xregdesign,...
   'callback','set(gcbf,''tag'',''cancel'');');
ud.okbtn=uicontrol('parent',figh,...
   'style','pushbutton',...
   'position',[528 7 65 25],...
   'string','OK',...
   'callback','set(gcbf,''tag'',''ok'');');
ud.optimdone=0;

flw=xregflowlayout(figh,'packstatus','off',...
   'orientation','right/center',...
   'elements',{ud.cancbtn,ud.okbtn},...
   'gap',8,'border',[0 0 -8 0]);
brd=xregborderlayout(figh,'south',flw,...
   'center',lyt,...
   'innerborder',[10 45 10 10],...
   'container',figh,...
   'packstatus','on');

set(figh,'visible','on','userdata',ud);
drawnow;
set(figh,'windowstyle','modal');

% block until Finish or Cancel is pressed
waitfor(figh,'tag');
tg=get(figh,'tag');
if strcmp(tg,'cancel')
   % cancel flag has been set
   ok=0;
   dout=d;
else
   % assume no cancel state
   ud=get(figh,'userdata');
   if ud.optimdone
      ok=2;
   else
      ok=1;
   end
   dout=p.info;
end
freeptr(p)
delete(figh);
return


function lyt=i_createlyt(figh,p,varargin)
if ~isa(figh,'xregcontainer')
   ud.pointer=p;
   ud.figure=figh;
   mnm=mfilename;
   [pth,mnm,ext,ver]=fileparts(mnm);
   udh=uicontrol('parent',figh,'visible','off',...
      'style','text',...
      'string','Optimality Criteria:',...
      'enable','inactive',...
      'horizontalalignment','left');
   ud.optpop=xreguicontrol('parent',figh,...
      'visible','off',...
      'style','popupmenu',...
      'backgroundcolor','w',...
      'string',{'D-Optimal','V-Optimal'},...
      'callback',{@i_critchng,udh});
   ud.startfcn='';
   ud.stopfcn='';
   % parse varargin for start/stop fcn
   for n=1:2:length(varargin)
      switch lower(varargin{n})
      case 'startfcn'
         ud.startfcn=varargin{n+1};
      case 'stopfcn'
         ud.stopfcn=varargin{n+1};
      end
   end
   
   ud.optimopt=gui_optimset(p.info,'layout',figh,p,'callback',{@i_optschng,udh});
   ud.optim=gui_optimise(p.info,'layout',figh,p,...
      'startoptfcn',{@i_optstart,udh},...
      'finishoptfcn',{@i_optstop,udh});
   lyt=xreggridbaglayout(figh,'dimension',[6 3],...
      'rowsizes',[5 3 15 2 15 -1],...
      'colratios',[10 19 29],...
      'gapx',10,...
      'mergeblock',{[6 6],[1 2]},...
      'mergeblock',{[2 4],[2 2]},...
      'mergeblock',{[1 6],[3 3]},...
      'elements',{[],[],udh,[],[],ud.optimopt,[],ud.optpop,[],[],[],[],ud.optim},...
      'packstatus','off',...
      'userdata',udh);
   i_setvalues(ud);
else
   lyt=figh;
   udh=get(lyt,'userdata');
   ud=get(udh,'userdata');
   
   ud.pointer=p;
   i_setvalues(ud);
   l=gui_optimset(p.info,'layout',ud.optimopt,p);
   l=gui_optimise(p.info,'layout',ud.optim,p);
end
set(udh,'userdata',ud);
return



function i_setvalues(ud)
p=ud.pointer;
optset=p.getoptimiser;
if strcmp(lower(optset),'d-optimal');
   val=1;
else
   val=2;
end
set(ud.optpop,'value',val)
return



function i_optschng(src,evt,udh)
ud=get(udh,'userdata');
% update optimisation half
l=gui_optimise(ud.pointer.info,'layout',ud.optim,ud.pointer);
return


function i_optstart(src,evt,udh)
ud=get(udh,'userdata');
% inactivate entire left hand of GUI
set(ud.optimopt,'enable','inactive');
% disable figure buttons - this is done by gui_optimise
% flag that an optimisation has been performed
fud=get(ud.figure,'userdata');
fud.optimdone=1;
set(ud.figure,'userdata',fud);
xregcallback(ud.startfcn,[],[]);
return

function i_optstop(src,evt,udh)
ud=get(udh,'userdata');
% reactivate entire left hand of GUI
gui_optimset(ud.pointer.info, 'enable', ud.optimopt, 'on');
% enable figure buttons - this is done by gui_optimise
xregcallback(ud.stopfcn,[],[]);
return


function i_critchng(src,evt,udh)

ud=get(udh,'userdata');

val=get(ud.optpop,'value');
str={'d-optimal','v-optimal'};
str=str{val};
p=ud.pointer;
p.info = p.setoptimiser(str);

i_optschng(src,evt,udh);
return

