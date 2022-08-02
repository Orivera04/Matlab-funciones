function [out,out2]=propertypage(obj,action,varargin)
%PROPERTYPAGE   Generate an editing page for this constraint
%
%  LYT=PROPERTYPAGE(OBJ,'CREATE',FIG,PTR,MDL,FACTORS)
%  [OK,MSG]= PROPERTYPAGE(OBJ,'FINALISE',LYT)
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.8.2.2 $  $Date: 2004/02/09 06:59:16 $

switch lower(action)
case 'create'
   out=i_createlyt(varargin{:});
   out2=[];
case 'finalise'
   [out,out2]=i_finalise(varargin{:});
end
return



function lyt=i_createlyt(fig,ptr,mdl,fact)

ud.figure=fig;
ud.model=mdl;
ud.ptr=ptr;
P=getparams(ptr.info);
ud.X=P.breakx;
ud.Y=P.table;
ud.factors=P.factors;
ud.le=P.le;
infoptr=xregGui.RunTimePointer;

xtxt=xreguicontrol('parent',fig,...
   'style','text',...
   'string','X factor:',...
   'visible','off',...
   'enable','inactive',...
   'horizontalalignment','left');
ytxt=xreguicontrol('parent',fig,...
   'style','text',...
   'string','Y factor:',...
   'visible','off',...
   'enable','inactive',...
   'horizontalalignment','left');

ud.factpop=[xreguicontrol('parent',fig,...
      'style','popupmenu',...
      'visible','off',...
      'string',fact,...
      'value',P.factors(1),...
      'BackGroundColor','w',...
      'callback',{@i_factorchange,infoptr,1}),...
      xreguicontrol('parent',fig,...
      'style','popupmenu',...
      'visible','off',...
      'string',fact,...
      'value',P.factors(2),...
      'BackGroundColor','w',...
      'callback',{@i_factorchange,infoptr,2})];

ineqtxt=xreguicontrol('parent',fig,...
   'style','text',...
   'string','Inequality:',...
   'visible','off',...
   'enable','inactive',...
   'horizontalalignment','left');
ud.ineq=xreguicontrol('parent',fig,...
   'style','popupmenu',...
   'visible','off',...
   'string',{'>=','<='},...
   'value',P.le+1,...
   'BackGroundColor','w',...
   'callback',{@i_ineqchange,infoptr});
ud.code=xreguicontrol('parent',fig,...
   'style','checkbox',...
   'visible','off',...
   'string','View coded values',...
   'value',0,...
   'callback',{@i_codechange,infoptr});

seltxt=xreguicontrol('parent',fig,...
   'style','text',...
   'string','Selected Point:',...
   'visible','off',...
   'enable','inactive',...
   'horizontalalignment','left');
ud.xsel=xreguicontrol('parent',fig,...
   'style','text',...
   'string',fact{P.factors(1)},...
   'visible','off',...
   'enable','inactive',...
   'horizontalalignment','left');
ud.ysel=xreguicontrol('parent',fig,...
   'style','text',...
   'string',fact{P.factors(2)},...
   'visible','off',...
   'enable','inactive',...
   'horizontalalignment','left');
ud.xselval=xreguicontrol('parent',fig,...
   'style','edit',...
   'visible','off',...
   'horizontalalignment','right',...
   'backgroundcolor','w',...
   'callback',{@i_valchange,infoptr});
ud.yselval=xreguicontrol('parent',fig,...
   'style','edit',...
   'visible','off',...
   'horizontalalignment','right',...
   'backgroundcolor','w',...
   'callback',{@i_valchange,infoptr});
ud.axes=xregGui.axes('parent',fig,...
   'fontsize',8,...
   'units','pixels',...
   'visible','off',...
   'box','on',...
   'tickdir','in',...
   'layer','top',...
   'buttondownfcn',{@i_axesclick,infoptr});
set(get(ud.axes,'xlabel'),'string',fact{P.factors(1)});
set(get(ud.axes,'ylabel'),'string',fact{P.factors(2)});
MM=MotionManager(fig);
ud.MM=MM;
ud.mm=xregGui.MotionManager;
ud.mm.UseExternalRef='on';
ud.mm.ExternalRef=ud.axes;
ud.mm.MouseInFcn={@i_mousein,infoptr,fig};
ud.mm.MouseOutFcn={@i_mouseout,infoptr,fig};
ud.mm.enable='off';
ud.vislistener=handle.listener(ud.axes,ud.axes.findprop('visible'),'PropertyPostSet',{@i_mmenable,ud.mm});
MM.RegisterManager(ud.mm);
ud.cursormode=1;
ud.pointer={'movearrow','addpoint','rempoint','zoomin','zoomout'};
ud.selpointind=1;
ud.bopfcn='';
ud.ptrTAG=[];

ud.line = patch(NaN,NaN,[0 .8 .8],'parent',ud.axes,...
   'edgecolor','b',...
   'hittest','off');
ud.points =line(NaN,NaN,'parent',ud.axes,...
   'linestyle','none',...
   'marker','o',...
   'markerfacecolor','b',...
   'markeredgecolor','none',...
   'markersize',8,...
   'interruptible','off',...
   'buttondownfcn',{@i_pointclick,infoptr});
ud.markpoint=line(NaN,NaN,'parent',ud.axes,...
   'visible','on',...
   'linestyle','none',...
   'marker','o',...
   'markerfacecolor',[.8 0 0],...
   'markeredgecolor','none',...
   'markersize',8,...
   'interruptible','off',...
   'hittest','off');
ud.movepoint=line(NaN,NaN,'parent',ud.axes,...
   'linestyle','none',...
   'marker','o',...
   'markerfacecolor','r',...
   'markeredgecolor','none',...
   'markersize',8,...
   'interruptible','off');

tt={'Move points','Add point','Remove point','Zoom in','Zoom out'};
ims={'move.bmp','addpoint.bmp','delpoint.bmp','zoomin.bmp','zoomout.bmp'};
sc=xregGui.SystemColors;
for n=1:5
   ud.btns(n)=xreguicontrol('parent',fig,...
      'style','togglebutton',...
      'visible','off',...
      'cdata',replacecolor(xregresload(ims{n},'bmp'),[0 255 0],double(sc.CTRL_BACK)),...
      'tooltip',tt{n},...
      'callback',{@i_modechange,infoptr,n});
end
ud.btns(6)=xreguicontrol('parent',fig,...
   'style','pushbutton',...
   'visible','off',...
   'cdata',replacecolor(xregresload('zoomtofit.bmp','bmp'),[0 255 0],double(sc.CTRL_BACK)),...
   'tooltip','Zoom to fit',...
   'callback',{@i_zoomtofit,infoptr});
set(ud.btns(1),'value',1);


grd=xreggridbaglayout(fig,...
   'dimension',[13 2],...
   'gapx',10,...
   'rowsizes',[3 15 2 5 3 15 2 5 3 15 2 5 20],...
   'colsizes',[50 -1],...
   'mergeblock',{[1 3],[2 2]},...
   'mergeblock',{[5 7],[2 2]},...
   'mergeblock',{[9 11],[2 2]},...
   'mergeblock',{[13 13],[1 2]},...
   'elements',{[],xtxt,[],[],[],ytxt,[],[],[],ineqtxt,[],[],ud.code,...
      ud.factpop(1),[],[],[],ud.factpop(2),[],[],[],ud.ineq},...
   'packstatus','off',...
   'border',[0 0 0 25]);

grd2=xreggridbaglayout(fig,...
   'dimension',[11 10],...
   'rowsizes',[3 15 2 5 24 24 24 24 24 24 -1],...
   'colsizes',[40 100 30 60 10 30 60 -1 5 24],...
   'mergeblock',{[1 3],[4 4]},...
   'mergeblock',{[1 3],[7 7]},...
   'mergeblock',{[5 11],[1 8]},...
   'elements',{[],[],[],ud.xselval,[],[],ud.yselval,[],[],[];...
      [],seltxt,ud.xsel,[],[],ud.ysel,[],[],[],[];...
      [],[],[],[],[],[],[],[],[],[];...
      [],[],[],[],[],[],[],[],[],[];...
      ud.axes,[],[],[],[],[],[],[],[],ud.btns(1);...
      [],[],[],[],[],[],[],[],[],ud.btns(2);...
      [],[],[],[],[],[],[],[],[],ud.btns(3);...
      [],[],[],[],[],[],[],[],[],ud.btns(4);...
      [],[],[],[],[],[],[],[],[],ud.btns(5);...
      [],[],[],[],[],[],[],[],[],ud.btns(6);...
      [],[],[],[],[],[],[],[],[],[];...
   },...
   'border',[0 40 0 0]);

lyt=xreggridlayout(fig,'correctalg','on',...
   'dimension',[1 2],...
   'gapx',60,...
   'colsizes',[130 -1],...
   'elements',{grd,grd2},...
   'userdata',infoptr);
   
infoptr.info=ud;

i_doaxlims(infoptr);
i_plot(infoptr);
i_plotsel(infoptr);
return


function i_doaxlims(ptr)
% reset axes limits
ud=ptr.info;
[L,U]=range(ud.model);
xlim=[L(ud.factors(1)) U(ud.factors(1))];
ylim=[L(ud.factors(2)) U(ud.factors(2))];
if get(ud.code,'value')
   xlim=code(ud.model,xlim(:),ud.factors(1))';
   ylim=code(ud.model,ylim(:),ud.factors(2))';
   xlim(1)=min(xlim(1),ud.X(1));
   xlim(2)=max(xlim(2),ud.X(end));
   ylim(1)=min(ylim(1),ud.Y(1));
   ylim(2)=max(ylim(2),ud.Y(end));
else
   xlim(1)=min(xlim(1),invcode(ud.model,ud.X(1),ud.factors(1)));
   xlim(2)=max(xlim(2),invcode(ud.model,ud.X(end),ud.factors(1)));
   ylim(1)=min(ylim(1),invcode(ud.model,ud.Y(1),ud.factors(2)));
   ylim(2)=max(ylim(2),invcode(ud.model,ud.Y(end),ud.factors(2)));
end
set(ud.axes,'xlim',xlim+100*[-eps eps],'ylim',ylim+100*[-eps eps]);
return



function i_plot(ptr)
ud=ptr.info;
% redo line and patch
if ~get(ud.code,'value');
   X=invcode(ud.model,[ud.X(:) ud.Y(:)],ud.factors);
   Y=X(:,2)';
   X=X(:,1)';
else
   X=ud.X;
   Y=ud.Y;
end
ineq=get(ud.ineq,'value')-1;
xlim=get(ud.axes,'xlim');
ylim=get(ud.axes,'ylim');
[Xp Yp]=i_createpatchdata(X,Y,xlim,ylim,ineq);
set(ud.points,'xdata',X,'ydata',Y);
set(ud.line,'xdata',Xp,'ydata',Yp);
return


function [X,Y]=i_createpatchdata(X,Y,xlim,ylim,ineq);
% check points against limits and extrapolate if necessary
if X(1)>xlim(1)
   X=[xlim(1) X];
   if X(3)==X(2)
      X(2)=X(2)-5*eps;
   end
   Y=[Y(1)+(X(1)-X(2)).*(Y(2)-Y(1))./(X(3)-X(2)) Y];
end
if X(end)<xlim(2)
   X(end+1)=xlim(2);
   if X(end-1)==X(end-2)
      X(end-1)=X(end-1)+5*eps;
   end
   Y(end+1)=Y(end-1)+(X(end)-X(end-2)).*(Y(end)-Y(end-1))./(X(end-1)-X(end-2));
end

% drop to top/bottom of axes
X=[X(1) X X(end)];
if ineq
   Y=[ylim(1) Y ylim(1)];
else
   Y=[ylim(2) Y ylim(2)];
end
return


function i_plotsel(ptr)
ud=ptr.info;
xd=get(ud.points,'xdata');
yd=get(ud.points,'ydata');
if ud.selpointind<=length(xd)
   set(ud.markpoint,'visible','on','xdata',xd(ud.selpointind),'ydata',yd(ud.selpointind));
   set(ud.xselval,'string',sprintf('%g',xd(ud.selpointind)),'enable','on');
   set(ud.yselval,'string',sprintf('%g',yd(ud.selpointind)),'enable','on');
else
   set(ud.markpoint,'visible','off');
   set(ud.xselval,'string','','enable','off');
   set(ud.yselval,'string','','enable','off');
end
return


function i_mmenable(src,evt,mm)
mm.enable=evt.AffectedObject.visible;
return


function i_mousein(src,evt,ptr,fig)
ud=ptr.info;
PR=xregGui.PointerRepository;
ud.ptrTAG=PR.stackSetPointer(fig,ud.pointer{ud.cursormode});
ptr.info=ud;
return

function i_mouseout(src,evt,ptr,fig)
ud=ptr.info;
PR=xregGui.PointerRepository;
PR.stackRemovePointer(fig,ud.ptrTAG);
return

function i_modechange(src,evt,ptr,btn)
ud=ptr.info;
if ud.cursormode==btn
   set(src,'value',1);  % set button back on
else
   set(ud.btns(ud.cursormode),'value',0);
   ud.cursormode=btn;
   ptr.info=ud;
end
return

function i_ineqchange(src,evt,ptr)
ud=ptr.info;
ud.le=get(src,'value')-1;
ptr.info=ud;
i_plot(ptr);
return

function i_codechange(src,evt,ptr)
ud=ptr.info;
docode=get(src,'value');

%code/invcode the current axes limits
xl=get(ud.axes,'xlim');
yl=get(ud.axes,'ylim');
if docode
   xl=code(ud.model,[xl(:),yl(:)],ud.factors);
   yl=xl(:,2)';
   xl=xl(:,1)';
else
   xl=invcode(ud.model,[xl(:),yl(:)],ud.factors);
   yl=xl(:,2)';
   xl=xl(:,1)';
end
set(ud.axes,'xlim',xl,'ylim',yl);

% replot the data values
i_plot(ptr);
i_plotsel(ptr);
return


function i_factorchange(src,evt,ptr,factind)
newval=get(src,'value');
ud=ptr.info;

if newval~=ud.factors(factind)
   fact=get(src,'string');
   NF=length(fact);
   factind2=find(ud.factors==newval);
   if ~isempty(factind2)
      % change another popup to keep each factor only used once
      avail=setdiff((1:NF),ud.factors((~(factind-1)+1)));
      set(ud.factpop(factind2),'value',avail(1));
      factind=[factind factind2];
   end
   val=get(ud.factpop,{'value'});
   val=[val{:}];
   ud.factors=val(:)';
   % update table
   [L,U]=range(ud.model);
   L=code(ud.model,[L(:)';U(:)']);
   U=L(2,:);
   L=L(1,:);
   for i=factind
      f=val(i);
      switch i
      case 1
         ud.X=linspace(L(f),U(f),length(ud.X));
      case 2
         ud.Y=repmat(U(f),1,length(ud.Y));
      end
   end
   ptr.info=ud;
   i_doaxlims(ptr);
   i_plot(ptr);
   i_plotsel(ptr);
   % set new x,y labels
   set(get(ud.axes,'xlabel'),'string',fact{val(1)});
   set(get(ud.axes,'ylabel'),'string',fact{val(2)});
   set(ud.xsel,'string',fact{val(1)});
   set(ud.ysel,'string',fact{val(2)});
end
return

function i_valchange(src,evt,ptr)
ud=ptr.info;
x=sscanf(get(ud.xselval,'string'),'%f');
y=sscanf(get(ud.yselval,'string'),'%f');
if ~(isempty(x) | isempty(y) | length(x)>1 | length(y)>1)
   if ~get(ud.code,'value')
      x=code(ud.model,x,ud.factors(1));
      y=code(ud.model,y,ud.factors(2));
   end
   ud.X(ud.selpointind)=x;
   ud.Y(ud.selpointind)=y;
   [ud.X,i]=sort(ud.X);
   ud.Y=ud.Y(i);
   ud.selpointind=find(i==ud.selpointind);
   ptr.info=ud;
   i_plot(ptr);
end
i_plotsel(ptr);
return

function i_pointclick(src,evt,ptr)
ud=ptr.info;
cp=get(ud.axes,'currentpoint');
% decide whether to select point
if ud.cursormode==1 | ud.cursormode==2
   xd=get(ud.points,'xdata');
   yd=get(ud.points,'ydata');
   [cpx,ind]=min(abs(yd-cp(2,2))+abs(xd-cp(2,1)));
   ud.selpointind=ind;
   ptr.info=ud;
   i_plotsel(ptr);
end
switch ud.cursormode
case 1
   set(ud.movepoint,'xdata',get(ud.markpoint,'xdata'),'ydata',get(ud.markpoint,'ydata'));
   ud.bupfcn=get(ud.figure,'windowbuttonupfcn');
   set(ud.figure,'windowbuttonupfcn',{@i_stopmove,ptr});
   ud.MM.MouseMoveFcn={@i_pointmove,ptr};
   ud.MM.EnableTree=false;
   ptr.info=ud;
case 3
   % check to see which point is selected, and remove it
   xd=get(ud.points,'xdata');
   yd=get(ud.points,'ydata');
   [cpx,ind]=min(abs(yd-cp(2,2))+abs(xd-cp(2,1)));
   ud.X(ind)=[];
   ud.Y(ind)=[];
   % check number of points remaining is >=2
   if length(ud.X)==2
      % go to move mode, disable remove points button
      set(ud.btns(3),'enable','off');
      set(ud.btns(1),'value',1);
      ptr.info=ud;
      i_modechange(ud.btns(1),evt,ptr,1);
      ud=ptr.info;
   end
   if ind==ud.selpointind;
      ud.selpointind=1;
   end 
   ptr.info=ud;
   i_plot(ptr);
   i_plotsel(ptr);
case {4,5}
   i_axesclick(src,evt,ptr);
end
return


function i_stopmove(src,evt,ptr)
ud=ptr.info;
ud.MM.MouseMoveFcn='';
ud.MM.EnableTree=true;
set(ud.figure,'windowbuttonupfcn',ud.bupfcn);
% get new position
xd=get(ud.movepoint,'xdata');
yd=get(ud.movepoint,'ydata');
nat=~get(ud.code,'value');
if nat
   xd=code(ud.model,xd,ud.factors(1));
   yd=code(ud.model,yd,ud.factors(2));
end
ud.X(ud.selpointind)=xd;
ud.Y(ud.selpointind)=yd;
[ud.X,i]=sort(ud.X);
ud.Y=ud.Y(i);
ud.selpointind=find(i==ud.selpointind);
ptr.info=ud;
i_plot(ptr);
i_plotsel(ptr);
set(ud.movepoint,'xdata',NaN,'ydata',NaN);
return

function i_pointmove(src,evt,ptr)
ud=ptr.info;
cp=get(ud.axes,'currentpoint');
xlim=get(ud.axes,'xlim');
ylim=get(ud.axes,'ylim');
cp=max(min(cp(2,1:2),[xlim(2) ylim(2)]),[xlim(1) ylim(1)]);
set(ud.movepoint,'xdata',cp(1),'ydata',cp(2));
set(ud.xselval,'string',sprintf('%g',cp(1)));
set(ud.yselval,'string',sprintf('%g',cp(2)));
drawnow;
return

function i_axesclick(src,evt,ptr)
ud=ptr.info;
cp=get(ud.axes,'currentpoint');
cp=cp(2,1:2);
switch ud.cursormode
case 2   % add point
   nat=~get(ud.code,'value');
   if nat
      cp=code(ud.model,cp,ud.factors);
   end
   ud.X(end+1)=cp(1);
   ud.Y(end+1)=cp(2);
   sel=length(ud.X);
   [ud.X,i]=sort(ud.X);
   ud.Y=ud.Y(i);
   ud.selpointind=find(i==sel);
   ptr.info=ud;
   i_plot(ptr);
   i_plotsel(ptr);
   set(ud.btns(3),'enable','on');
case 4  % zoom in
   % get current limits
   xlim=get(ud.axes,'xlim');
   ylim=get(ud.axes,'ylim');
   % Halve the range, centre about cp
   xlim=cp(1)+0.25.*(xlim(2)-xlim(1)).*[-1 1];
   ylim=cp(2)+0.25.*(ylim(2)-ylim(1)).*[-1 1];
   set(ud.axes,'xlim',xlim);
   set(ud.axes,'ylim',ylim);
   i_plot(ptr); 
case 5 % zoom out
   % get current limits
   xlim=get(ud.axes,'xlim');
   ylim=get(ud.axes,'ylim');
   % Double the range, centre about cp
   xlim=cp(1)+(xlim(2)-xlim(1)).*[-1 1];
   ylim=cp(2)+(ylim(2)-ylim(1)).*[-1 1];
   set(ud.axes,'xlim',xlim);
   set(ud.axes,'ylim',ylim);
   i_plot(ptr);   
end
return

function i_zoomtofit(src,evt,ptr)
ud=ptr.info;
docode=get(ud.code,'value');
[L U]=range(ud.model);
L=code(ud.model,L);
U=code(ud.model,U);

lim=[L(ud.factors); U(ud.factors)];
lim(1,:)=min(lim(1,:),[ud.X(1) min(ud.Y)]);
lim(2,:)=max(lim(2,:),[ud.X(end) max(ud.Y)]);

if ~docode
   lim=invcode(ud.model, lim , ud.factors);
end
lim = lim + 100*[-eps -eps; eps eps];
set(ud.axes,'xlim',lim(:,1)',...
   'ylim',lim(:,2)');
i_plot(ptr);
return


function [ok,msg]=i_finalise(lyt)
ud=get(lyt,'userdata');
ud=ud.info;
[c,msg]=setparams(ud.ptr.info,'breakx',ud.X,'table',ud.Y,'factors',ud.factors,'le',ud.le);
ud.ptr.info=c;
ok= isempty(msg);
return