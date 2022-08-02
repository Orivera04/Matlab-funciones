function mmprobe3(arg)
%MMPROBE3 Probe Data on 3D Axis Using Mouse. (MM)
% MMPROBE3 duplicates the current figure containing a 3D surface
% and creates three other subplots containing: a contour plot of 
% the surface, a 2D line plot of Z vs X at a specific Y value, and
% a 2D line plot of Z vs Y at a specific X value.
%
% The two line plots can be changed by dragging the corresponding
% marker line in the contour plot, or by entering the desired X or Y
% values into the edit boxes provided.
%
% Pressing the following keys with the mouse over the plot causes the
% following actions:
% p   moves the marker lines so thay they intersect at the global peak.
% v   moves the marker lines so thay they intersect at the global valley.
% g   toggles the presence of grids on the two line plots.
% x   toggles the presence of points on the contour plot showing the
%     min (o) and max (x) of Z for each grid point along the X-axis.
% y   toggles the presence of points on the contour plot showing the
%     min (o) and max (x) of Z for each grid point along the Y-axis.
% r   forces a refresh of the figure window.
% N   where N is a digit between 1 and 9 redraws the contour plot with
%     10+N contour levels.

% Calls: mmgcf mmfitpos mmget mmax mmin mminxy

% D.C. Hanselman, University of Maine, Orono, ME, 04469
% 3/23/98, 3/21/01
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9


if nargin==0
   Hf=mmgcf(1);
   H=findobj(0,'Type','figure','Tag','MMPROBE3');
   if ~isempty(H)
      figure(H)
      return
   end
   Ha=findobj(Hf,'type','axes');
   if length(Ha)>1
      error('Figure Must Contain Only a Single Axes.')
   end
   arg='initial';
end
switch lower(arg)
case 'initial'
   Hs=findobj(Ha,'Type','surface');
   if isempty(Hs)
      error('Axes Must Contain One Surface.')
   elseif length(Hs)>1
      error('Axes Must Contain Only One Surface.')
   end
   Hf=copyobj(Hf,0);
   dfp=get(0,'DefaultFigurePosition');
   fp=mmfitpos([dfp(1)-0.5*dfp(3) dfp(2)-0.5*dfp(4) 1.5*dfp(3:4)],0,'pixels');
   set(Hf,'Units','pixels','Position',fp,...
      'BackingStore','off',...
      'Name','MMPROBE3',...
      'NumberTitle','off',...
      'NextPlot','add',...
      'Renderer','painters',...
      'WindowButtonUpFcn','mmprobe3 buttonup',...
      'KeyPressFcn','mmprobe3 keypress',...
      'ResizeFcn','mmprobe3 resize',...
      'Tag','MMPROBE3')
   v=get(Ha,'view');
   Ha=get(Hf,'CurrentAxes');
   pos=zeros(4);
   pos(:,1)=[.08;  .56; .08; .56]; % lefts
   pos(:,2)=[.56; .56; .06; .06];  % bottoms
   pos(:,3)=.38;                   % widths
   pos(:,4)=1.05*pos(:,3);         % heights
   w=pos(1,3)/3; w2=2*w; h=.04; b=pos(3,2)+pos(1,4)+.003;
   pos(5,:)=[pos(1,1)     b  w2  h]; 
   pos(6,:)=[pos(1,1)+w2  b  w   h];
   pos(7,:)=[pos(2,1)     b  w2  h];
   pos(8,:)=[pos(2,1)+w2  b  w   h];
   
   [Hx,Hy,Hz,xlim,ylim,zlim]=mmget(Ha,'Xlabel','Ylabel','Zlabel',...
      'Xlim','Ylim','Zlim');
   set(Ha,'Units','normalized',...  % surface plot
      'Position',pos(1,:),...
      'DrawMode','fast',...
      'View',v,'Box','on',...
      'Xlim',xlim,'Ylim',ylim,'Zlim',zlim)
   Hs=findobj(Ha,'Type','surface');
   [xd,yd,zd]=mmget(Hs,'Xdata','Ydata','Zdata');
   [msg,xd,yd,zd]=xyzchk(xd,yd,zd);
   error(msg)
   xlim=[min(xd(:)) max(xd(:))];
   ylim=[min(yd(:)) max(yd(:))];
   set(Hs,'Xdata',xd,'Ydata',yd,'Zdata',zd,...
      'Tag','MMPROBE3 Surface')
   Xstr=get(Hx,'String');
   if isempty(Xstr), Xstr='X'; set(Hx,'String',Xstr), end
   Ystr=get(Hy,'String');
   if isempty(Ystr), Ystr='Y'; set(Hy,'String',Ystr), end
   Zstr=get(Hz,'String');
   if isempty(Zstr), Zstr='Z'; set(Hz,'String',Zstr), end
   
   Hac=axes('Units','normalized',... % contour plot
      'Position',pos(2,:),...
      'NextPlot','add',...
      'DrawMode','fast',...
      'Box','on',...
      'Xlim',xlim,...
      'Ylim',ylim,...
      'Tag','MMPROBE3 Contour');
   contour(xd,yd,zd)
   
   [Xx,Yx,Zx,Xy,Yy,Zy]=mminxy(xd,yd,zd);
   line('Parent',Hac,'XData',Xx,'YData',Yx,... % X min line
      'LineStyle','none',...
      'Marker','o',...
      'MarkerSize',4,...
      'Color',[1 .5 .5],...
      'Tag','MMPROBE3 XMM',...
      'Visible','off')
   line('Parent',Hac,'XData',Xy,'YData',Yy,... % Y min line
      'LineStyle','none',...
      'Marker','o',...
      'MarkerSize',4,...
      'Color',[.5 .5 1],...
      'Tag','MMPROBE3 YMM',...
      'Visible','off')
   [Xx,Yx,Zx,Xy,Yy,Zy]=mminxy(xd,yd,-zd);
   line('Parent',Hac,'XData',Xx,'YData',Yx,... % X max line
      'LineStyle','none',...
      'Marker','x',...
      'MarkerSize',6,...
      'Color',[1 .5 .5],...
      'Tag','MMPROBE3 XMM',...
      'Visible','off')
   line('Parent',Hac,'XData',Xy,'YData',Yy,... % Y max line
      'LineStyle','none',...
      'Marker','x',...
      'MarkerSize',6,...
      'Color',[.5 .5 1],...
      'Tag','MMPROBE3 YMM',...
      'Visible','off')
   
   [xlab,ylab]=mmget(Hac,'XLabel','YLabel');
   set(xlab,'String',Xstr)
   set(ylab,'String',Ystr)
   xl=(xlim(1)+xlim(2))/2;
   yl=(ylim(1)+ylim(2))/2;
   
   set(Ha,'Xtick',get(Hac,'XTick'))
   set(Ha,'Ytick',get(Hac,'YTick'))
   
   line('Parent',Ha,... % Vertical Line in Surface
      'Xdata',[xl xl],...
      'Ydata',[yl yl],...
      'Zdata',zlim,...
      'LineStyle','-',...
      'LineWidth',2,...
      'Color',get(Ha,'ZColor'),...
      'EraseMode','xor',...
      'Tag','MMPROBE3 SLine')
   
   line('Parent',Hac,'Xdata',xlim,'Ydata',[yl yl],... % horizontal drag line
      'LineStyle','--',...
      'LineWidth',2,...
      'ButtonDownFcn','mmprobe3 horizontal',...
      'Tag','MMPROBE3 HDrag',...
      'Erasemode','xor',...
      'Color','r');
   line('Parent',Hac,'Xdata',[xl xl],'Ydata',ylim,... % vertical drag line
      'LineStyle','--',...
      'LineWidth',2,...
      'ButtonDownFcn','mmprobe3 vertical',...
      'Tag','MMPROBE3 VDrag',...
      'Erasemode','xor',...
      'Color','b');
   
   axes('Units','normalized','position',pos(3,:),... % Vline plot
      'Box','on','DrawMode','fast',...
      'XGrid','on','YGrid','on',...
      'Xlim',ylim,'Ylim',zlim,...
      'Tag','MMPROBE3 Vline');
   zvert=interp2(xd,yd,zd,xl+zeros(size(yd,1),1),yd(:,1));
   line('Xdata',yd(:,1),'Ydata',zvert,...
      'Color','b',...
      'EraseMode','xor',...
      'Tag','MMPROBE3 Vline')
   xlabel(Ystr)
   ylabel(Zstr)
   
   Hlp=axes('Units','normalized','position',pos(4,:),... % Hline plot
      'Box','on','DrawMode','fast',...
      'XGrid','on','YGrid','on',...
      'Xlim',xlim,'Ylim',zlim,...
      'Tag','MMPROBE3 Hline');
   zhoriz=interp2(xd,yd,zd,xd(1,:),yl+zeros(1,size(xd,2)));
   Hl=line('Xdata',xd(1,:),'Ydata',zhoriz,...
      'Color','r',...
      'EraseMode','xor',...
      'Tag','MMPROBE3 Hline');
   xlabel(Xstr)
   ylabel(Zstr)
   
   set(Ha,'ZTick',get(Hlp,'Ytick'))
   
   H=uicontrol('Style','text',... % Static text for Z vs. Y plot
      'Units','normalized',...
      'Position',pos(5,:),...
      'BackgroundColor',get(gcf,'Color'),...
      'String',[Xstr ' = '],...
      'HorizontalAlignment','Right',...
      'Tag','MMPROBE3 uistatic');
   p=get(H,'extent');
   pos(5,:)=[pos(5,1)+pos(5,3)-1.1*p(3) pos(5,2) 1.1*p(3) 1.05*p(4)];
   set(H,'Position',pos(5,:))
   uicontrol('Style','edit',... % Edit text for Z vs. Y
      'Units','normalized',...
      'Position',[pos(6,1:3) 1.3*p(4)],...
      'String',sprintf('%.3g',xl),...
      'HorizontalAlignment','left',...
      'Tag','MMPROBE3 Xvalue',...
      'UserData',xlim,...
      'Callback','mmprobe3 xvalue')
   
   H=uicontrol('Style','text',... % Static text for Z vs. X plot
      'Units','normalized',...
      'Position',pos(7,:) ,...
      'BackgroundColor',get(gcf,'Color'),...
      'String',[Ystr ' = '],...
      'HorizontalAlignment','Right',...
      'Tag','MMPROBE3 uistatic');
   p=get(H,'extent');
   pos(7,:)=[pos(7,1)+pos(7,3)-1.1*p(3) pos(7,2) 1.1*p(3) 1.05*p(4)];
   set(H,'position',pos(7,:))
   
   uicontrol('Style','edit',... % Edit text for Z vs. X
      'Units','normalized',...
      'Position',[pos(8,1:3) 1.3*p(4)],...
      'String',sprintf('%.3g',yl),...
      'HorizontalAlignment','left',...
      'Tag','MMPROBE3 Yvalue',...
      'UserData',ylim,...
      'Callback','mmprobe3 yvalue')
   
case 'horizontal' % horizontal line is pressed
   [Hl,Hf]=gcbo;
   setptr(Hf,'uddrag')
   set(Hf,'WindowButtonMotionFcn','mmprobe3 uddrag')
   
case 'uddrag' % dragging horizontal line
   Ha=gca;
   Hl=findobj(Ha,'Tag','MMPROBE3 HDrag');
   [p,ylim]=mmget(Ha,'CurrentPoint','Ylim');
   yy=p(:,2);
   p=p(1,2);
   if p>ylim(1) & p<ylim(2)
      set(Hl,'Ydata',yy,'UserData',1)
   end
   
case 'vertical' % vertical line is pressed
   [Hl,Hf]=gcbo;
   setptr(Hf,'lrdrag')
   set(Hf,'WindowButtonMotionFcn','mmprobe3 lrdrag')
   
case 'lrdrag' % dragging vertical line
   Ha=gca;
   Hl=findobj(Ha,'Tag','MMPROBE3 VDrag');
   [p,xlim]=mmget(Ha,'CurrentPoint','Xlim');
   xx=p(:,1);
   p=p(1,1);
   if p>xlim(1) & p<xlim(2)
      set(Hl,'Xdata',xx,'UserData',1)
   end
   
case 'buttonup' % buttonup in window: update plots
   Hf=gcbf;
   set(Hf,'Pointer','Arrow',...
      'WindowButtonMotionFcn','')
   Hs=findobj(Hf,'Type','surface','Tag','MMPROBE3 Surface');
   [xd,yd,zd]=mmget(Hs,'Xdata','Ydata','Zdata');
   
   Hls=findobj(Hf,'Type','line','Tag','MMPROBE3 SLine');
   
   Hl=findobj(Hf,'Type','line','Tag','MMPROBE3 HDrag');
   [yy,tf]=mmget(Hl,'Ydata','UserData');
   if tf  % horizontal has changed
      zhoriz=interp2(xd,yd,zd,xd(1,:),yy(1)+zeros(1,size(xd,2)));
      Hl=findobj(Hf,'Type','line','Tag','MMPROBE3 Hline');
      set(Hl,'Xdata',xd(1,:),'Ydata',zhoriz,'UserData',0)
      
      Hui=findobj(Hf,'Type','uicontrol','Tag','MMPROBE3 Yvalue');
      set(Hui,'String',sprintf('%.3g',yy(1)))
      
      set(Hls,'Ydata',yy)
   end
   
   Hl=findobj(Hf,'Type','line','Tag','MMPROBE3 VDrag');
   [xx,tf]=mmget(Hl,'Xdata','UserData');
   if tf  % vertical has changed
      zvert=interp2(xd,yd,zd,xx(1)+zeros(size(yd,1),1),yd(:,1));
      Hl=findobj(Hf,'Type','line','Tag','MMPROBE3 Vline');
      set(Hl,'Xdata',yd(:,1),'Ydata',zvert)
      
      Hui=findobj(Hf,'Type','uicontrol','Tag','MMPROBE3 Xvalue');
      set(Hui,'String',sprintf('%.3g',xx(1)))
      
      set(Hls,'Xdata',xx)
   end
   
case 'xvalue' % value changed in X value edit box
   Hf=gcbf;
   Hui=findobj(Hf,'Type','uicontrol','Tag','MMPROBE3 Xvalue');
   x=eval(get(Hui,'String'),'[]');
   xlim=get(Hui,'UserData');
   if isempty(x) | x<xlim(1) | x>xlim(2) % Wrong edit text
      Hl=findobj(Hf,'Type','line','Tag','MMPROBE3 SLine');
      x=get(Hl,'Xdata');
      set(Hui,'String',sprintf('%.3g',x(1)))
   else
      Hl=findobj(Hf,'Type','line','Tag','MMPROBE3 VDrag');
      set(Hl,'Xdata',[x x],'UserData',1);
      mmprobe3 buttonup
   end
   
case 'yvalue' % value changed in Y value edit box
   Hf=gcbf;
   Hui=findobj(Hf,'Type','uicontrol','Tag','MMPROBE3 Yvalue');
   y=eval(get(Hui,'string'),'[]');
   ylim=get(Hui,'UserData');
   if isempty(y) | y<ylim(1) | y>ylim(2) % Wrong edit text
      Hl=findobj(Hf,'Type','line','Tag','MMPROBE3 SLine');
      y=get(Hl,'Ydata');
      set(Hui,'String',sprintf('%.3g',y(1)))
   else
      Hl=findobj(Hf,'Type','line','Tag','MMPROBE3 HDrag');
      set(Hl,'Ydata',[y y],'UserData',1);
      mmprobe3 buttonup
   end
   
case 'resize'
   Hf=gcbf;
   Huis=findobj(Hf,'Type','uicontrol','Tag','MMPROBE3 uistatic');
   [p,pos]=mmget(Huis(1),'Extent','Position');
   pos=[pos(1)+pos(3)-1.1*p(3) pos(2) 1.1*p(3) 1.05*p(4)];
   set(Huis(1),'Position',pos)
   [p,pos]=mmget(Huis(2),'Extent','Position');
   pos=[pos(1)+pos(3)-1.1*p(3) pos(2) 1.1*p(3) 1.05*p(4)];
   set(Huis(2),'Position',pos)
   
   Hui=findobj(Hf,'Type','uicontrol','Tag','MMPROBE3 Xvalue');
   p=get(Hui,'Extent');
   pos=get(Hui,'Position');
   set(Hui,'Position',[pos(1:3) 1.3*p(4)])
   Hui=findobj(Hf,'Type','uicontrol','Tag','MMPROBE3 Yvalue');	
   pos=get(Hui,'Position');
   set(Hui,'Position',[pos(1:3) 1.3*p(4)])
   
case 'keypress'
   
   Hf=gcbf;
   k=lower(get(Hf,'CurrentCharacter'));
   switch k
   case 'p' % go to global peak
      Hs=findobj(Hf,'Type','surface','Tag','MMPROBE3 Surface');
      [xd,yd,zd]=mmget(Hs,'Xdata','Ydata','Zdata');
      [zp,c]=max(max(zd));
      [zp,r]=max(max(zd'));
      xp=xd(1,c);
      yp=yd(r,1);
      
      Hl=findobj(Hf,'type','line','Tag','MMPROBE3 VDrag');
      set(Hl,'Xdata',[xp;xp],'UserData',1)	
      Hl=findobj(Hf,'type','line','Tag','MMPROBE3 HDrag');
      set(Hl,'Ydata',[yp;yp],'UserData',1)		
      mmprobe3 buttonup
      
   case 'v' % go to global valley
      Hs=findobj(Hf,'Type','surface','Tag','MMPROBE3 Surface');
      [xd,yd,zd]=mmget(Hs,'Xdata','Ydata','Zdata');
      [zp,c]=min(min(zd));
      [zp,r]=min(min(zd'));
      xp=xd(1,c);
      yp=yd(r,1);
      
      Hl=findobj(Hf,'type','line','Tag','MMPROBE3 VDrag');
      set(Hl,'Xdata',[xp;xp],'UserData',1)	
      Hl=findobj(Hf,'type','line','Tag','MMPROBE3 HDrag');
      set(Hl,'Ydata',[yp;yp],'UserData',1)		
      mmprobe3 buttonup
      
   case 'g' % toggle grids
      Hah=findobj(Hf,'Type','axes','Tag','MMPROBE3 Hline');
      Hav=findobj(Hf,'Type','axes','Tag','MMPROBE3 Vline');
      if strcmp(get(Hah,'Xgrid'),'on')
         set([Hah;Hav],'Xgrid','off','YGrid','off')
      else
         set([Hah;Hav],'Xgrid','on','YGrid','on')
      end
      
   case 'x' % find min and max along x-axis
      Hl=findobj(Hf,'Type','line','Tag','MMPROBE3 XMM');
      if strcmp(get(Hl,'Visible'),'on')
         set(Hl,'Visible','off')
      else
         set(Hl,'Visible','on')
      end
      
   case 'y' % find min and max along y-axis
      Hl=findobj(Hf,'Type','line','Tag','MMPROBE3 YMM');
      if strcmp(get(Hl,'Visible'),'on')
         set(Hl,'Visible','off')
      else
         set(Hl,'Visible','on')
      end
      
   case {'1' '2' '3' '4' '5' '6' '7' '8' '9' '0'}
      Hac=findobj(Hf,'Type','axes','Tag','MMPROBE3 Contour');
      Hp=findobj(Hac,'Type','patch');
      n=10+sscanf(k,'%d',1);
      delete(Hp)
      Hs=findobj(Hf,'Type','surface','Tag','MMPROBE3 Surface');
      [xd,yd,zd]=mmget(Hs,'Xdata','Ydata','Zdata');
      axes(Hac)
      contour(xd,yd,zd,n)
      
   case 'r' % refresh
      refresh
   end
end
