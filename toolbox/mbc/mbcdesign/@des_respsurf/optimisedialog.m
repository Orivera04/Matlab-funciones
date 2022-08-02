function [d,ok]=optimisedialog(d)
%OPTIMISEDIALOG  Optimise design and show a blocking dialog
%
%  [D,OK]=OPTIMISEDIALOG(D) start an optimisation on D and puts
%  up a dialog to show progress and give the user a chance to 
%  cancel and finish early.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.5.2.5 $  $Date: 2004/04/04 03:26:46 $

[d,ok]=i_createfig(d);

return




function [dout,ok]= i_createfig(d)

scr=get(0,'screensize');
fig=xregfigure('visible','off',...
   'resize','off',...
   'name','Optimizing Design',...
   'position',[(scr(3)-350).*0.5 (scr(4)-280).*0.5 350 280],...
   'renderer','painters');
PR=xregGui.PointerRepository;
PR.SetPointer(fig,'backbusy');

ptr=xregGui.RunTimePointer;
ptr.LinkToObject(fig);
optim=getoptimiser(d);

switch lower(optim)
case 'd-optimal'
   infostr='Optimizing design to attain maximum D-optimal value.';
   valstr='Current D-optimal value:';
case 'v-optimal'
   infostr='Optimizing design to attain minimum V-optimal value.';
   valstr='Current V-optimal value:';
case 'a-optimal'
   infostr='Optimizing design to attain minimum A-optimal value.';
   valstr='Current A-optimal value:';  
end

ud.infotxt=uicontrol('parent',fig,...
   'style','text',...
   'horizontalalignment','left',...
   'string',infostr);
ud.axes=axes('parent',fig,...
   'units','pixels',...
   'box','on',...
   'fontsize',9);
ud.startpoint=line('parent',ud.axes,...
   'linestyle','none',...
   'marker','o',...
   'markersize',8,...
   'markerfacecolor',[0 0 1],...
   'markeredgecolor','none',...
   'xdata',0,...
   'ydata',0);
ud.historyline=line('parent',ud.axes,...
   'linestyle','-',...
   'marker','none',...
   'color',[0 0 1],...
   'xdata',0,...
   'ydata',0);
psival=uicontrol('style','text',...
   'parent',fig,...
   'string',valstr,...
   'horizontalalignment','left');
iternumber=uicontrol('style','text',...
   'parent',fig,...
   'string','Number of iterations performed:',...
   'horizontalalignment','left');
qnumber=uicontrol('style','text',...
   'parent',fig,...
   'string','Number of iterations without improvement:',...
   'horizontalalignment','left');
ud.psival=uicontrol('style','text',...
   'parent',fig,...
   'horizontalalignment','left');
ud.iternumber=uicontrol('style','text',...
   'parent',fig,...
   'horizontalalignment','left');
ud.qnumber=uicontrol('style','text',...
   'parent',fig,...
   'horizontalalignment','left');
cancelbtn= uicontrol('parent',fig,...
   'style','pushbutton',...
   'string','Cancel',...
   'callback',{@i_cancel,ptr});
stopbtn= uicontrol('parent',fig,...
   'style','pushbutton',...
   'string','Accept',...
   'callback',{@i_stop,ptr});
set(fig,'closerequestfcn',{@i_cancel,ptr});

ud.next=1;
ud.iters=[];
ud.psis=[];
ud.design=d;
ud.ok=1;
ud.qmax=0;
ud.itermax=0;
ptr.info=ud;


ax=xreglayerlayout(fig,'packstatus','off',...
   'elements',{ud.axes},...
   'border',[40 30 40 30]);
lyt=xreggridbaglayout(fig,'dimension',[5 3],...
   'rowsizes',[15 -1 15 15 15],...
   'colsizes',[205 80 -1],...
   'gapx',5,'gapy',5,...
   'mergeblock',{[1 1],[1 3]},...
   'mergeblock',{[2 2],[1 3]},...
   'elements',{ud.infotxt,ax,psival,iternumber,qnumber,[],[],ud.psival,ud.iternumber,ud.qnumber});

lyt=xreggridbaglayout(fig,'dimension',[2 3],...
   'rowsizes',[-1 25],...
   'colsizes',[-1 65 65],...
   'gapx',7,'gapy',10,...
   'border',[10 10 10 15],...
   'mergeblock',{[1 1],[1 3]},...
   'elements',{lyt,[],[],stopbtn,[],cancelbtn});
fig.LayoutManager=lyt;
set(lyt,'packstatus','on');

i_setvalues(ptr);

set(fig,'visible','on');
drawnow;
set(fig,'windowstyle','modal');

try
   dout=optimise(d,1,{@i_initoptim,ptr},{@i_updateoptim,ptr},{@i_termoptim,ptr});
catch
   delete(fig);
   error('Error during optimization');
end
ud=ptr.info;
if ~ud.ok
   dout=d;
end
ok=ud.ok;
delete(fig);
return



function i_setvalues(ptr)
ud=ptr.info;
d=ud.design;
optim=getoptimiser(d);
switch lower(optim)
case 'd-optimal'
   [psi, d]=dcalc(d);
   if isempty(psi)
      psi=0;
   end
   ylim=[min(0,psi) psi+abs(psi)*0.2];
case 'v-optimal'
   [psi, d]=vcalc(d);
   if isempty(psi)
      psi=5;
   end
   ylim=[min(0,psi) psi+abs(psi)*0.2];
case 'a-optimal'
   [psi, d]=acalc(d);
   if isempty(psi)
      psi=5;
   end
   ylim=[min(0,psi) psi+abs(psi)*0.2];
end

[delt,q,maxiter]=getstop(d);

ud.qmax=q;
ud.itermax=maxiter;
set(ud.axes,'ylim',ylim,'xlim',[0 maxiter]);
set(ud.startpoint,'xdata',0,'ydata',psi);
set(ud.historyline,'xdata',NaN,'ydata',NaN);
set(ud.iternumber,'string','0');
str=sprintf('%8.6f',psi);
set(ud.psival,'string',str(str~=' '));
set(ud.qnumber,'string',sprintf('0/%d',q));
ptr.info=ud;
return



function i_initoptim(des,evt,ptr)
ud=ptr.info;

% clear/create persistent history of data
ud.psis=zeros(1,ud.itermax+1);
ud.psis(1)=get(ud.startpoint,'ydata');
ud.iters=zeros(1,ud.itermax+1);
%set(ud.historyline,'erasemode','none');
ptr.info=ud;
return


function next=i_updateoptim(des,evt,ptr)
ud=ptr.info;
n=sum(ud.iters~=0)+2;
ud.psis(n)=evt.newpsi;
ud.iters(n)=evt.iteration;
ptr.info=ud;
clr= [evt.q./ud.qmax 0 1-evt.q./ud.qmax];

ylim=get(ud.axes,'ylim');
if evt.newpsi>(ylim(2) - 0.1);
   newmxy = 1.5*evt.newpsi;
   set(ud.axes,'ylim',ylim+[0 newmxy]); 
   drawnow;
   % need to repaint line completely
   set(ud.historyline,'erasemode','none','xdata',ud.iters(1:n),'ydata',ud.psis(1:n),'color',[0 0 1]);
else
   set(ud.historyline,'erasemode','none','xdata',ud.iters(1:n),'ydata',ud.psis(1:n),'color',[0 0 1]);
   %set(ud.historyline,'erasemode','xor','xdata',ud.iters(n-1:n),'ydata',ud.psis(n-1:n),'color',clr);
end

str=sprintf('%8.6f',evt.newpsi);
set(ud.psival,'string',str(str~=' '));
set(ud.iternumber,'string',sprintf('%d',evt.iteration));
set(ud.qnumber,'string',sprintf('%d/%d',evt.q,ud.qmax));
drawnow;
next=ud.next;
return

function i_termoptim(des,evt,ptr)
ud=ptr.info;
n=sum(ud.iters~=0)+1;
set(ud.historyline,'erasemode','normal','xdata',ud.iters(1:n),'ydata',ud.psis(1:n));
set(ud.infotxt,'string','Terminating optimization...');
return

function i_cancel(src,evt,ptr)
% stop optimisation and set a cancel flag
ud=ptr.info;
ud.next=0;
ud.ok=0;
ptr.info=ud;
return

function i_stop(src,evt,ptr)
% stop optimisation and set an ok flag
ud=ptr.info;
ud.next=0;
ud.ok=1;
ptr.info=ud;
return