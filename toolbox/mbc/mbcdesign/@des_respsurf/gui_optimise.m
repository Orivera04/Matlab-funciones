function [dout,ok]=gui_optimise(d,action,varargin)
% GUI_OPTIMISE  Design optimisation GUI
%
%    [D,OK]=GUI_OPTIMISE(D) brings up a modal dialog for optimising
%    the design D.
%    LYT=GUI_OPTIMISE(D,'layout',FIG,P) creates a layout object 
%    working with pointer P in the figure FIG.  
%    LYT=GUI_OPTIMISE(D,'infolayout',FIG,P) creates a layout object
%    with the additional information frame above the optimising 
%    controls, as in the figure option.
%    LYT=GUI_OPTIMISE(D,'layout',LYT,P) updates previously created
%    layout LYT with a new pointer P.  Similarly for 'infolayout'.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 07:03:41 $



if nargin<2
   action='figure';
end

switch lower(action)
case 'figure'
   [dout,ok]=i_createfigure(d);
case 'layout'
   dout=i_createlyt(varargin{:});
   ok=1;
case 'infolayout'
   % create layout with info pane on top
   dout=i_createduallyt(varargin{:});
   ok=1;
case 'grid'
   i_grid(varargin{:});
case 'optimise'
   i_optimise(varargin{:});
case 'samplerate'
   i_samplerate(varargin{:});
case 'resizefig'
   figh=varargin{1};
   ud=get(figh,'userdata');
   % limit size
   pos=get(figh,'position');
   repack(ud.layout);
end




function [dout,ok]=i_createfigure(d);

% can only optimise a rank-checked design
if ~rankcheck(d)
   h=errordlg(['This design has not been initialized with enough points.',...
         '  You must reinitialize it before optimizing.'],'Error');
   dout=d;
   ok=0;
   return
end


scsz=get(0,'screensize');
figh=figure('menubar','none',...
   'toolbar','none',...
   'numbertitle','off',...
   'name','Optimization',...
   'color',get(0,'defaultuicontrolbackgroundcolor'),...
   'doublebuffer','on',...
   'visible','off',...
   'position',[scsz(3).*0.5-125 scsz(4).*0.5-175 325 500],...
   'tag','Optimisation',...
   'renderer','zbuffer',...
   'closerequestfcn','set(gcbf,''tag'',''cancel'');');

p=xregpointer(d);
lyt=i_createduallyt(figh,p);

% ok and cancel
ud.okbtn = uicontrol('parent',figh,...
   'string','OK',...
   'style','pushbutton',...
   'callback','set(gcbf,''tag'',''ok'');',...
   'position',[0 0 65 25],...
   'userdata',d,...
   'enable','off');
ud.cancbtn = uicontrol('parent',figh,...
   'string','Cancel',...
   'style','pushbutton',...
   'callback','set(gcbf,''tag'',''cancel'');',...
   'position',[0 0 65 25]);
flw=xregflowlayout(figh,'orientation','right/bottom',...
   'elements',{ud.cancbtn,ud.okbtn},...
   'gap',7,...
   'border',[0 10 -7 10]);
brd=xregborderlayout(figh,'center',lyt,'south',flw,...
   'innerborder',[10 45 10 10],...
   'container',figh,...
   'packstatus','on');
set(lyt,'visible','on');
ud.layout=brd;
set(figh,'userdata',ud,'resizefcn',...
   ['gui_optimise(get(' sprintf('%20.15f',ud.okbtn) ',''userdata''),''resizefig'',gcbf);'],...
   'visible','on');
drawnow;
set(figh,'windowstyle','modal');

waitfor(figh,'tag');
tg=get(figh,'tag');
switch lower(tg)
case 'ok'
   dout=p.info;
   ok=1;      
case 'cancel'
   dout=d;
   ok=0;     
end

delete(figh);
return





function lyt=i_createlyt(figh,p,varargin)

if ~isa(figh,'xregcontainer')
   ud.statustext=uicontrol('style','text',...
      'parent',figh,...
      'string','Idle.',...
      'horizontalalignment','left',...
      'visible','off');
   ud.axes=axes('parent',figh,...
      'units','pixels',...
      'box','on',...
      'visible','off',...
      'fontsize',9);
   ud.startpoint=line('parent',ud.axes,...
      'linestyle','none',...
      'marker','o',...
      'markersize',8,...
      'markerfacecolor',[0 0 1],...
      'markeredgecolor','none',...
      'xdata',0,...
      'ydata',0,...
      'visible','off');
   ud.endpoint=line('parent',ud.axes,...
      'linestyle','none',...
      'marker','o',...
      'markersize',8,...
      'markerfacecolor',[1 0 0],...
      'markeredgecolor','none',...
      'xdata',NaN,...
      'ydata',NaN,...
      'visible','off');
   ud.historyline=line('parent',ud.axes,...
      'linestyle','-',...
      'marker','none',...
      'color',[0 0 1],...
      'xdata',0,...
      'ydata',0,...
      'visible','off');
   ud.psival=uicontrol('style','text',...
      'parent',figh,...
      'string','Psi value: ',...
      'horizontalalignment','left',...
      'position',[0 0 150 15],...
      'visible','off');
   ud.iternumber=uicontrol('style','text',...
      'parent',figh,...
      'string','Iteration: 0',...
      'horizontalalignment','left',...
      'position',[0 0 140 15],...
      'visible','off');
   ud.qnumber=uicontrol('style','text',...
      'parent',figh,...
      'string','q value: 0',...
      'horizontalalignment','left',...
      'position',[0 0 80 15],...
      'visible','off');
   xgtext=uicontrol('style','text',...
      'parent',figh,...
      'string','X-Grid:',...
      'horizontalalignment','left',...
      'position',[0 0 40 15],...
      'visible','off');
   ud.roller{1}=roller(figh,...
      'position',[0 0 20 15],...
      'string',{'off','on'},...
      'backgroundcolor','w',...
      'visible','off');
   spctext=uicontrol('style','text',...
      'parent',figh,...
      'position',[0 0 50 15],...
      'visible','off');
   ygtext=uicontrol('style','text',...
      'parent',figh,...
      'position',[0 0 40 15],...
      'string','Y-Grid:',...
      'horizontalalignment','left',...
      'visible','off');
   ud.roller{2}=roller(figh,...
      'position',[0 0 20 15],...
      'string',{'off','on'},...
      'backgroundcolor','w',...
      'visible','off');
   text1=uicontrol('style','text',...
      'parent',figh,...
      'position',[0 0 85 15],...
      'string','Output sampling:',...
      'horizontalalignment','left',...
      'visible','off');
   text2=uicontrol('style','text',...
      'parent',figh,...
      'position',[0 0 65 16],...
      'string','Sample every',...
      'horizontalalignment','left',...
      'visible','off');
   ud.cedit=xregGui.clickedit(figh,...
      'position',[0 0 45 20],...
      'min',1,...
      'max',999,...
      'rule','int',...
      'dragincrement',1,...
      'clickincrement',1,...
      'value',1,...
      'visible','off');
   text3=uicontrol('style','text',...
      'parent',figh,...
      'position',[0 0 45 16],...
      'string','iterations',...
      'horizontalalignment','left',...
      'visible','off');
   ud.optimise=uicontrol('parent',figh,...
      'style','pushbutton',...
      'string','Optimise',...
      'position',[0 0 65 25],...
      'visible','off');
   ud.stop=uicontrol('parent',figh,...
      'style','pushbutton',...
      'string','Stop',...
      'position',[0 0 65 25],...
      'enable','off',...
      'visible','off');
   
   ud.pointer=p;
   ud.figure=figh;
   ud.startoptfcn='';
   ud.finishoptfcn='';
   ud.optimrunning=0;
   if nargin>2
      for n=1:2:length(varargin)
         switch lower(varargin{n})
         case 'startoptfcn'
            ud.startoptfcn=varargin{n+1};
         case 'finishoptfcn'
            ud.finishoptfcn=varargin{n+1};
         end
      end
   end

   % set up object and userdata
   objh=sprintf('%20.15f',ud.statustext);
   builtin('set',ud.statustext,'userdata',des_respsurf);
   udh=sprintf('%20.15f',ud.axes);
   set(ud.axes,'userdata',ud);
   
   % set up callbacks
   basestr=['gui_optimise(get(' objh ',''userdata''),'];
   set(ud.roller{1},'callback',[basestr '''grid'',''x'',%VALUE%,' udh ');']);
   set(ud.roller{2},'callback',[basestr '''grid'',''y'',%VALUE%,' udh ');']);
   set(ud.optimise,'callback',[basestr '''optimise'',' udh ');']);
   set(ud.cedit,'callback',[basestr '''samplerate'',' udh ');']);
   set(ud.stop,'callback',@i_stoptheoptim);
   
   
   % layout
   ud.axes=axiswrapper(ud.axes);
   axeswrap=xregborderlayout(figh,'center',ud.axes,...
      'innerborder',[20 30 10 10],...
      'packstatus','off');
   flwbutts=xregflowlayout(figh,'orientation','right',...
      'elements',{ud.stop,ud.optimise},...
      'gap',7,...
      'border',[0 0 -7 10]);
   flwdetails=xregflowlayout(figh,'orientation','left/top',...
      'elements',{ud.iternumber,ud.psival});
   grd=xreggridlayout(figh,'dimension',[2 1],...
      'correctalg','on',...
      'elements',{flwdetails,ud.qnumber});
   flwgrid=xregflowlayout(figh,'orientation','left/center',...
      'elements',{xgtext,ud.roller{1},spctext,ygtext,ud.roller{2}});
   flwoutput=xregflowlayout(figh,'orientation','left/center',...
      'elements',{text1,text2,ud.cedit,text3},...
      'gap',5,...
      'border',[-5 0 0 0]);
   grd2=xreggridlayout(figh,'dimension',[2 1],...
      'elements',{flwgrid,flwoutput},...
      'correctalg','on');
   optsfrm=xregframetitlelayout(figh,'title','Options',...
      'center',grd2,...
      'innerborder',[15 10 10 10],...
      'border',[0 0 0 10],...
      'visible','off');
   subbrd=xregborderlayout(figh,'north',grd,...
      'center',optsfrm,...
      'south',flwbutts,...
      'innerborder',[0 35 0 35]);
   bfr=xreglayerlayout(figh,'elements',{ud.statustext},'border',[0 10 0 0]);
   mainbrd=xregborderlayout(figh,'north',bfr,...
      'center',axeswrap,...
      'south',subbrd,...
      'innerborder',[0 165 0 25]);
   lyt=xregframetitlelayout(figh,...
      'title','Optimisation',...
      'center',mainbrd,...
      'innerborder',[15 10 10 10],...
      'visible','off');
   i_optgraph('changesamplerate',1);
else
   lyt=figh;
   ax=get(get(get(lyt,'center'),'center'),'center');
   ud=get(ax,'userdata');
   ud.pointer=p;
   if nargin>2
      for n=1:2:length(varargin)
         switch lower(varargin{n})
         case 'startoptfcn'
            ud.startoptfcn=varargin{n+1};
         case 'finishoptfcn'
            ud.finishoptfcn=varargin{n+1};
         end
      end
   end
   set(ax,'userdata',ud);
end

% update data in objects
i_setvalues(ud,p);
return




function i_setvalues(ud,p)
d=p.info;
str=getoptimiser(d);
switch str
case 'd-optimal'
   [psi, d]=dcalc(d);
   if isempty(psi)
      psi=0;
   end
   ylim=[min(0,psi) psi+abs(psi)*0.2];
   optstr='D-optimality';
case 'v-optimal'
   [psi, d]=vcalc(d);
   if isempty(psi)
      psi=5;
   end
   ylim=[min(0,psi) psi+abs(psi)*0.2];
   optstr='V-optimality';
otherwise
   [psi, d]=acalc(d);
   if isempty(psi)
      psi=5;
   end
   ylim=[min(0,psi) psi+abs(psi)*0.2];
   optstr='A-optimality'; 
end
% keep the calculations we've just done
p.info=d;
xlim=[0 d.maxiter];
set(ud.startpoint,'xdata',0,'ydata',psi);
set(ud.endpoint,'xdata',NaN,'ydata',NaN);
set(ud.historyline,'xdata',[],'ydata',[]);
set(ud.axes,'ylim',ylim,'xlim',xlim);
set(ud.psival,'string',[optstr ' value: ' sprintf('%8.4f',psi)]);
return



function i_grid(dir,val,udh)
% turn gridlines on/off
ud=get(udh,'userdata');

if val
   st='on';
else
   st='off';
end

if strcmp(dir,'x')
   set(ud.axes,'xgrid',st);
elseif strcmp(dir,'y')
   set(ud.axes,'ygrid',st);
end
if ud.optimrunning
   % redraw current history line
   i_optgraph('quickrefresh');
end
return



function i_samplerate(udh)
ud=get(udh,'userdata');

i_optgraph('changesamplerate',get(ud.cedit,'value'));

return



function i_optimise(udh)
ud=get(udh,'userdata');
rsd=ud.pointer.info;

fud=get(ud.figure,'userdata');
TurnOKOn=0;
if isfield(fud,'okbtn') & isfield(fud,'cancbtn')
   set([fud.okbtn;fud.cancbtn],'enable','off');
   TurnOKOn=1;
end
% set up optimisation buttons and cut out wizard movement
set(ud.stop,'enable','on');
set(ud.optimise,'enable','off');

set(ud.figure,'pointer','custom','pointershapecdata',backbusyptr,'pointershapehotspot',[1 1]);
xregcallback(ud.startoptfcn);
try
   rsd=optimise(rsd,1,{@i_initoptim,ud.axes},{@i_updateoptim,ud.axes},{@i_termoptim,ud.axes});
   ud.pointer.info=rsd;
catch
   h=errordlg(['There was an error during optimization.  The initial design may be ',...
         'rank-deficient - try reinitializing the design and then optimizing'],...
      'Optimisation Error');
   waitfor(h);
end
xregcallback(ud.finishoptfcn);
set(ud.stop,'enable','off');
set(ud.optimise,'enable','on');
set(ud.statustext,'string','Idle.');
if TurnOKOn
   set([fud.okbtn;fud.cancbtn],'enable','on');
end
set(ud.figure,'pointer','arrow');
return


function i_initoptim(rsd,evt,udh)
i_optgraph('init',udh);
return

function next=i_updateoptim(rsd,evt,udh)
next=i_optgraph('quickadd',evt.newpsi,evt.iteration,evt.q);
return

function i_termoptim(rsd,evt,udh)
i_optgraph('finish',udh);
return

function i_stoptheoptim(src,evt)
i_optgraph('changesamplerate',0);
return



function out=i_optgraph(action,varargin)

persistent psis iters next psitext itertext qtext lineh ax ylim qmax optstr
% psis and iters hold data
% next is the number of iterations between samples
% psitext, itertext, qtext, lineh and ax are handles

switch action
case 'init'
   udh=varargin{1};
   ud=get(udh,'userdata');
   d=ud.pointer.info;
   set(ud.statustext,'string','Initializing...');
   
   i_optgraph('resetstartpoint',udh);
   
   % set limits etc on graph
   % set graph x,ylim
   set(ud.axes,'xlim',[0 d.maxiter]);
   set(ud.historyline,'erasemode','normal','xdata',[],'ydata',[]);
   drawnow;
   % clear/create persistent history of data
   psis=zeros(1,d.maxiter+1);
   psis(1)=get(ud.startpoint,'ydata');
   iters=zeros(1,d.maxiter+1);
   if isempty(next)
      next=1;
   end
   
   qmax=d.q;
   psitext=ud.psival;
   itertext=ud.iternumber;
   qtext=ud.qnumber;
   ax=ud.axes;
   lineh=ud.historyline;
   optstr=get(psitext,'string');
   optstr=optstr(1:12);
   set(ud.statustext,'string','Optimizing...');
   ud.optimrunning=1;
   set(ax,'userdata',ud);
  
case 'finish'
   udh=varargin{1};
   % redraw line output and clear persistent variables
   ud=get(udh,'userdata');
   set(ud.statustext,'string','Terminating...');
   n=sum(iters~=0)+1;
   set(lineh,'erasemode','normal','xdata',iters(1:n),'ydata',psis(1:n));
   set(ud.endpoint,'xdata',iters(n),'ydata',psis(n));
   
   next=get(ud.cedit,'value');
   psis=[];
   iters=[];
   psitext=[];
   itertext=[];
   qtext=[];
   lineh=[];
   ax=[];
   optstr='';
   qmax=[];
   ylim=[];
   drawnow;
   ud.optimrunning=0;
   set(ud.axes,'userdata',ud);
case 'quickadd'
   
   n=sum(iters~=0)+2;
   psis(n)=varargin{1};
   iters(n)=varargin{2};
   
   clr= [varargin{3}./qmax 0 1-varargin{3}./qmax];
   if varargin{1}>(ylim(2) - 0.1);
      set(ax,'ylim',ylim+[0 .5]); 
      drawnow;
      ylim=ylim+[0 0.5];
      % need to repaint line completely
      set(lineh,'erasemode','none','xdata',iters(1:n),'ydata',psis(1:n),'color',[0 0 1]);
   else
      set(lineh,'erasemode','none','xdata',iters(n-1:n),'ydata',psis(n-1:n),'color',clr);
   end
   
   set(psitext,'string',[optstr ' value: ' sprintf('%8.4f',varargin{1})]);
   set(itertext,'string',['Iteration: ' sprintf('%d',varargin{2})]);
   set(qtext,'string',['q value: ' sprintf('%d',varargin{3})]);
   
   drawnow;
   out=next;
 
case 'quickrefresh'
   % rewrite graph with current history data
   if ~isempty(iters)
      n=sum(iters~=0)+1;
      set(lineh,'erasemode','none','xdata',iters(1:n),'ydata',psis(1:n));
   else
      set(lineh,'erasemode','none','xdata',[],'ydata',[]);
   end
   drawnow;
   
case 'changesamplerate'
   % update persistent variable
   next=varargin{1};
   
case 'resetstartpoint'
   % redraw the startpoint using current psi value
   udh=varargin{1};
   ud=get(udh,'userdata');
   d=ud.pointer.info;
   
   str=getoptimiser(d);
   switch str
   case 'd-optimal'
      psi=dcalc(d);
      ylim=[min(0,psi) psi+abs(psi).*0.2];
   case 'v-optimal'
      psi=vcalc(d);
      ylim=[min(0,psi) psi+abs(psi).*0.2];
   otherwise
      psi=acalc(d);
      ylim=[min(0,psi) psi+abs(psi).*0.2];
   end   
   set(ud.startpoint,'xdata',0,'ydata',psi);
   set(ud.endpoint,'xdata',NaN,'ydata',NaN);
   set(ud.axes,'ylim',ylim);
end
return




function lyt=i_createinfolyt(figh,p)
if ~isa(figh,'xregcontainer')
   ud.txt(1)=uicontrol('style','text',...
      'parent',figh,...
      'horizontalalignment','left',...
      'visible','off',...
      'string','Optimality criteria:');  
   ud.txt(2)=uicontrol('style','text',...
      'parent',figh,...
      'horizontalalignment','left',...
      'visible','off',...
      'string','New points tried at each iteration:');
   ud.txt(3)=uicontrol('style','text',...
      'parent',figh,...
      'horizontalalignment','left',...
      'visible','off',...
      'string','Maximum consecutive unsuccessful iterations:');
   ud.txt(4)=uicontrol('style','text',...
      'parent',figh,...
      'horizontalalignment','left',...
      'visible','off');
   ud.txt(5)=uicontrol('style','text',...
      'parent',figh,...
      'horizontalalignment','left',...
      'visible','off');
   ud.txt(6)=uicontrol('style','text',...
      'parent',figh,...
      'horizontalalignment','left',...
      'visible','off');
   ud.pointer=p;
   
   set(ud.txt(1),'userdata',ud);
   
   grd=xreggridlayout(figh,'correctalg','on',...
      'dimension',[3 2],'colratios',[4 1],...
      'elements',{ud.txt(1),ud.txt(2),ud.txt(3),ud.txt(4),ud.txt(5),ud.txt(6)});
   lyt=xregframetitlelayout(figh,'visible','off',...
      'center',grd,'title','Current settings',...
      'innerborder',[15 10 10 10]);
else
   lyt=figh;
   el=get(get(lyt,'center'),'elements');
   el=el{1};
   ud=get(el,'userdata');
   ud.pointer=p;
   set(el,'userdata',ud);
end
i_setinfovalues(ud,p);
return


function i_setinfovalues(ud,p)
str=p.getoptimiser;
% capitalise optimality letter
str(1)=upper(str(1));
set(ud.txt(4),'string',str);
set(ud.txt(5),'string',p.getoptimal);
[delt,q]=getstop(p.info);
set(ud.txt(6),'string',q);
return



function lyt=i_createduallyt(figh,p,varargin)
if ~isa(figh,'xregcontainer')
   % function to call both optional layouts and put them together
   lyt1=i_createlyt(figh,p,varargin{:});
   set(lyt1,'border',[0 0 0 5]);
   % info layout
   lyt2=i_createinfolyt(figh,p);
   set(lyt2,'border',[0 5 0 0]);
   lyt=xregborderlayout(figh,'north',lyt2,'center',lyt1,'innerborder',[0 0 0 100]);
else
   lyt=figh;
   i_createlyt(get(lyt,'center'),p,varargin{:});
   i_createinfolyt(get(lyt,'north'),p);
end
return

