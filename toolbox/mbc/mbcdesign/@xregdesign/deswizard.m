function [des, canc]=deswizard(des,action,udh);
% DESIGN/DESWIZARD   GUI wizard for setting up a design
%   D=DESWIZARD(D) displays a wizard GUI for setting up options
%   and creating an optimal design.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 07:06:28 $



if nargin<2
   action='create';
end

switch lower(action);
case 'create'
   [des,canc]=i_createfig(des);
   
case 'next'
   % flip to next view
   ud=get(udh,'userdata');
   set(ud.figure,'pointer','watch');
   n=get(ud.crd,'currentcard')+1;
   if n>length(ud.drawn)
      % rogue action: terminate
      set(ud.figure,'pointer','arrow');
      return
   end
   
   % finalise current view
   lyt=getcard(ud.crd);
   msg=feval(ud.fns{n-1},ud.pointer.info,'finalise',lyt{1});
   if ~isempty(msg)
      % error - tell user and cancel operation
      h=errordlg(msg,'Error','modal');
      waitfor(h);
      set(ud.figure,'pointer','arrow');
      return
   end
   
   if ~ud.drawn(n)
      lyt=feval(ud.fns{n},ud.pointer.info,'layout',ud.figure,ud.pointer);
      attach(ud.crd,lyt,n);
      set(lyt,'packstatus','on');
      ud.drawn(n)=1;
   else
      lyt=getcard(ud.crd,n);
      lyt=feval(ud.fns{n},ud.pointer.info,'layout',lyt{1},ud.pointer);
   end
   set(ud.crd,'currentcard',n);
   set(ud.figure,'pointer','arrow','name',ud.titles{n});
   
   if n==length(ud.fns)
      set(ud.finish,'enable','on');
      set(ud.next,'enable','off');
   end
   if n==2
      set(ud.back,'enable','on');
   end
   drawnow;
   % look ahead and load next card
   if n<3 & ~ud.drawn(n+1)
      lyt=feval(ud.fns{n+1},ud.pointer.info,'layout',ud.figure,ud.pointer);
      attach(ud.crd,lyt,n+1);
      set(lyt,'packstatus','on');
      ud.drawn(n+1)=1;
   end 
   
   set(udh,'userdata',ud);
       
case 'back'
   % flip to last view
   ud=get(udh,'userdata');
   set(ud.figure,'pointer','watch');
   n=get(ud.crd,'currentcard')-1;
   if n<1
      set(ud.figure,'pointer','arrow');
      return
   end
   % get layout and update
   lyt=getcard(ud.crd,n);
   lyt=feval(ud.fns{n},ud.pointer.info,'layout',lyt{1},ud.pointer);
   % switch cards
   set(ud.crd,'currentcard',n);
   set(udh,'userdata',ud); 
   if n==(length(ud.fns)-1);
      set(ud.finish,'enable','off');
      set(ud.next,'enable','on');
   end
   if n==1
      set(ud.back,'enable','off');
      set(ud.next,'enable','on');
   end
   set(ud.figure,'pointer','arrow','name',ud.titles{n});
end
return



function [desout,canc]=i_createfig(des);
mnm=mfilename;
[pth,mnm,ext,ver]=fileparts(mnm);

ud.titles={'Design Wizard - Step 1 of 3 - Candidate Point Generation';...
      'Design Wizard - Step 2 of 3 - Create Initial Design';...
      'Design Wizard - Step 3 of 3 - Optimization'};

scrsz=get(0,'screensize');
% Create figure and set up userdata structure to track form completion
% and creation status (ie is tab made yet) and an array of handles that
% aer being used as userdata holders for each view
fig=figure('position',[scrsz(3)/2-340 scrsz(4)/2-220 680 425],...
   'tag','DesignWizard',...
   'visible','off',...
   'units','pixels',...
   'toolbar','none',...
   'menubar','none',...
   'numbertitle','off',...
   'name',ud.titles{1},...
   'resize','off',...
   'doublebuffer','on',...
   'pointer','watch',...
   'closerequestfcn','set(gcbf,''tag'',''cancel'');',...
   'color',get(0,'defaultuicontrolbackgroundcolor'));

% set up position control buttons
ud.cancel=uicontrol('parent',fig,...
   'style','pushbutton',...
   'position',[316 7 65 25],...
   'string','Cancel',...
   'userdata',xregdesign,...
   'callback','set(gcbf,''tag'',''cancel'');',...
   'interruptible','off');
ud.back=uicontrol('parent',fig,...
   'style','pushbutton',...
   'position',[388 7 65 25],...
   'string','< Back',...
   'interruptible','off');
ud.next=uicontrol('parent',fig,...
   'style','pushbutton',...
   'position',[456 7 65 25],...
   'string','Next >',...
   'interruptible','off');
ud.finish=uicontrol('parent',fig,...
   'style','pushbutton',...
   'position',[528 7 65 25],...
   'string','Finish',...
   'callback','set(gcbf,''tag'',''ok'');',...
   'interruptible','off');

objh=sprintf('%20.15f',ud.cancel);
udh=sprintf('%20.15f',fig);

set(ud.back,'callback',[mnm '(get(' objh ',''userdata''),''back'',' udh ');']);
set(ud.next,'callback',[mnm '(get(' objh ',''userdata''),''next'',' udh ');']);

% set button enable status
set([ud.cancel;ud.back;ud.next;ud.finish],{'enable'},{'on';'off';'on';'off'});
ud.drawn=zeros(1,4);
ud.fns={'candgui','modelgui','optimgui'};
p= xregpointer(des);
ud.pointer=p;
ud.figure=fig;

lyt=feval(ud.fns{1},p.info,'layout',fig,p);
ud.drawn(1)=1;

ud.crd=xregcardlayout(fig,'numcards',4);
attach(ud.crd,lyt,1);
set(lyt,'visible','on');

brd=xreggridbaglayout(fig,'dimension',[2 7],...
   'rowsizes',[-1 25],...
   'colsizes',[-1 65 10 65 65 10 65],...
   'gapy',10,...
   'border',[10 10 10 10],...
   'mergeblock',{[1 1],[1 7]},...
   'elements',{ud.crd,[],[],ud.cancel,[],[],[],ud.back,[],ud.next,[],[],[],ud.finish},...
   'container',fig,...
   'packstatus','on');

set(fig,'userdata',ud);
set(fig,'visible','on','pointer','arrow');
drawnow;
set(fig,'windowstyle','modal');

% immediately create next card layout
lyt=feval(ud.fns{2},p.info,'layout',fig,p);
ud.drawn(2)=1;
attach(ud.crd,lyt,2);
set(lyt,'packstatus','on');
set(fig,'userdata',ud);
set([ud.cancel;ud.back;ud.next;ud.finish],{'enable'},{'on';'off';'on';'off'});

% block until Finish or Cancel is pressed
waitfor(fig,'tag');
tg=get(fig,'tag');
if strcmp(tg,'cancel')
   % cancel flag has been set
   canc=1;
   desout=des;
else
   % assume no cancel state
   canc=0;
   desout=p.info;
end
freeptr(p);
delete(fig);

return

   
   
   
   