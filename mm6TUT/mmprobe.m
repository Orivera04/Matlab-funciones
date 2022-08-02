function mmprobe(arg)
%MMPROBE Probe Data on 2D Axis Using Mouse. (MM)
% MMPROBE places two vertical and two horizontal markers on
% the current axes to be dragged as desired using the mouse.
% The Mantissa of the axis coordinate is displayed next to
% each marker line. The text area below the x-axis shows:
%    dX = horizontal distance between vertical markers
%    dY = vertical distance between horizontal markers
% dY/dX = abs(slope) between marker box diagonal corners 
%  1/dX = inverse of dX (frequency)
%  Diag = distance between marker box diagonal corners
% Angle = angle between marker box diagonal corners (degrees)
%
% Holding the Control key down as you drag moves both horizontal or
% vertical lines in unison.
% Pressing the following keys with the mouse over the plot causes the
% following actions:
% z       zooms the plot into the box defined by the marker lines.
% o       zooms the plot out to the Original axis limits.
% x       zooms the x-axis between the Vertical marker lines.
% y       zooms the y-axis between the Horizontal marker lines.
% (space) opens a dialog box for specifying exact marker line positions.
% g       toggles the presence of an axis grid
% ?       issues >> helpwin mmprobe
% s       appends the currently displayed data in the Command window variable
%         PROBE_M, where the (i)th data point is stored in the (i)th row as
%         PROBE_M(i,:)=[dX dY 1/dX dY/dX Diag Angle];
%
% To interpolate plotted data, click and drag on a plotted line. Holding the
% Control key down as you drag shows a tangent line as well.
% The text area below the x-axis shows:
%     X = interpolated x-axis point on data line
%     Y = interpolated y-axis point on data line
% Slope = slope at interpolated point computed by quadratic curve fit through
%         nearest three points
% Angle = angle of slope at the chosen point (degrees)
%
% Pressing the following keys with the mouse over the plot when a data point
% is shown causes the following actions:
%
% i  interpolates the chosen line and moves to the user-selected X-axis point.
% ,  the marked data point jumps to the zero slope point to the left of
%    the currently displayed point, where the zero slope point is found by
%    quadratic interpolation thru the three points closest to the peak.
% .  the marked data point jumps to the right in the same manner.
% <  the marked data point jumps to the nearest peak or valley in the raw data
%    to the left of the currently displayed point.
% >  the marked data point jumps to the right in the same manner.
% v  moves the vertical marker lines so they cross at the intersection
%    of the selected line and the horizontal markers if such points exist.
% h  moves the horizontal marker lines so they cross at the intersection
%    of the chosen line and the vertical markers nearest the chosen data 
%    point if such points exist.
% m  moves the nearest horizontal and vertical markers so they cross at
%    the chosen data point.
% z  moves the marked data point to the nearest zero crossing.
% 0,1,2,3,4, or 5 finds the least squares polynomial of the associated order
%    that fits the chosen line using data between the vertical markers. 
%    The polynomial and norm(error,inf) at fitted points are displayed.
% d  deletes the marked data point and unselects the line.
% s  appends the currently displayed data in the Command window variable
%    PROBE_I, where the (i)th data point is stored in the (i)th row as
%    PROBE_I(i,:)=[X Y Slope Angle];
%    If a polynomial is displayed, the polynomial is appended to the
%    Command window variable PROBE_P forming a matrix whose (i)th row is
%    the displayed polynomial.
%
% Clicking on an open area of the figure window outside the plot
% or issuing MMPROBE off removes all MMPROBE features.
% PROBE_M, PROBE_I, and PROBE_P must be cleared by the user.

% Calls: mmgcf mmgca mmlog10 mmgetpos mmgetsiz mmget mmgetpt mmis2d mmpeaks
% Calls: mmp2str mminterp mmsearch mmp2pm mmprintf

% D.C. Hanselman, University of Maine, Orono, ME, 04469
% Rewritten 10/29/97, 11/19/97, 11/22/97, 12/29/97, 2/1/98, 3/19/98
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

global MMPROBE_

if nargin==0  % MMPROBE
   Hf=mmgcf(1);
   H=findobj(0,'Type','axes','Tag','MMPROBE');
   if ~isempty(H)
      figure(get(H,'Parent'))
      return
   end
   Ha=mmgca(Hf,1);
   arg='initial';
end
switch lower(arg)
case 'initial' %----------------------------------------------------
   set(Hf,'WindowButtonUpFcn','mmprobe reset',...
      'ButtonDownFcn','mmprobe off',...
      'BackingStore','off',...
      'KeyPressFcn','mmprobe keypress')
   set(Ha,'Tag','MMPROBE')
   
   [xc,yc,xl,yl,xlm,ylm,xdir,ydir,xsc,ysc,fu,fs,fn]=mmget(Ha,...
      'Xcolor','Ycolor',...
      'Xlim','Ylim',...
      'XlimMode','YlimMode',...
      'Xdir','Ydir',...
      'XScale','Yscale',...
      'FontUnits','FontSize','FontName');
   if ~mmis2d(Ha)
      error('Axis Must be 2D.')
   end
   if strcmp(xsc,'log')|strcmp(ysc,'log')
      error('X and Y Axes Must be Linear.')
   end
   if isempty(MMPROBE_)
      MMPROBE_.Ha=Ha;
      MMPROBE_.Alim=[xl yl];
      MMPROBE_.Xmode=xlm;
      MMPROBE_.Ymode=ylm;
      MMPROBE_.Hxl=get(Ha,'Xlabel');
      MMPROBE_.Xls=get(MMPROBE_.Hxl,'string');
   end
   
   Hl=findobj(Ha,'Type','line');
   if isempty(Hl), error('No Lines in Current Axes.'), end
   set(Hl,'ButtonDownFcn',...
      ['set(gcf,''WindowButtonMotionFcn'',''mmprobe interpolate'');'...
         'mmprobe interpolate'])
   
   dx=xl(2)-xl(1);
   X12=[1 9]/10*dx+xl(1);
   xm=xl(1)+dx/100;
   if strcmp(xdir,'reverse')
      xm=xl(2)-dx/100;
   end
   
   dy=yl(2)-yl(1);
   Y12=[1 9]/10*dy+yl(1);
   ym=yl(1);
   if strcmp(ydir,'reverse')
      ym=yl(2);
   end
   
   xym=mmlog10([X12 Y12])*1e2;
   em='xor'; lw=1.0; ls='--'; % line parameters
   MMPROBE_.H=zeros(4,2);
   %   MMPROBE_.H=[V1_line V1_text % handles for marker lines and text
   %               V2_line V2_text
   %               H1_line H1_text
   %               H2_line H2_text]
   
   cb=['set(gcf,''WindowButtonMotionFcn'',''mmprobe lrdrag''), '...
         'setptr(gcf,''lrdrag'')'];
   MMPROBE_.H(1,1)=line('Xdata',[1 1]*X12(1),...  % vertical line 1
      'Ydata',yl,...
      'Linestyle',ls,...
      'LineWidth',lw,...
      'Erasemode',em,...
      'Color',xc,...
      'HandleVisibility','callback',...
      'ButtonDownFcn',cb,...
      'UserData',1);
   MMPROBE_.H(1,2)=text('Position',[X12(1) ym],...
      'Erasemode',em,...
      'FontUnits',fu,...
      'Fontsize',fs,...
      'HorizontalAlignment','right',...
      'VerticalAlignment','bottom',...
      'Color',xc,...
      'HandleVisibility','on',...
      'String',sprintf('%.0f',xym(1)),...
      'ButtonDownFcn','mmprobe editline',...
      'UserData',1);
   
   MMPROBE_.H(2,1)=line('Xdata',[1 1]*X12(2),...  % vertical line 2
      'Ydata',yl,...
      'Linestyle',ls,...
      'LineWidth',lw,...
      'Erasemode',em,...
      'Color',xc,...
      'HandleVisibility','callback',...
      'ButtonDownFcn',cb,...
      'UserData',2);
   MMPROBE_.H(2,2)=text('Position',[X12(2) ym],...
      'Erasemode',em,...
      'FontUnits',fu,...
      'Fontsize',fs,...
      'HorizontalAlignment','left',...
      'VerticalAlignment','bottom',...
      'Color',xc,...
      'HandleVisibility','on',...
      'String',sprintf('%.0f',xym(2)),...
      'ButtonDownFcn','mmprobe editline',...
      'UserData',2);
   
   cb=['set(gcf,''WindowButtonMotionFcn'',''mmprobe uddrag''), '...
         'setptr(gcf,''uddrag'')'];	
   MMPROBE_.H(3,1)=line('Xdata',xl,...  % horizontal line 1
      'Ydata',[1 1]*Y12(1),...
      'Linestyle',ls,...
      'LineWidth',lw,...
      'Erasemode',em,...
      'Color',yc,...
      'HandleVisibility','callback',...
      'ButtonDownFcn',cb,...
      'UserData',3);
   MMPROBE_.H(3,2)=text('Position',[xm Y12(1)],...
      'Erasemode',em,...
      'FontUnits',fu,...
      'Fontsize',fs,...
      'HorizontalAlignment','left',...
      'VerticalAlignment','top',...
      'Color',yc,...
      'HandleVisibility','on',...
      'String',sprintf('%.0f',xym(3)),...
      'ButtonDownFcn','mmprobe editline',...
      'UserData',3);
   
   MMPROBE_.H(4,1)=line('Xdata',xl,...  % horizontal line 2
      'Ydata',[1 1]*Y12(2),...
      'Linestyle',ls,...
      'LineWidth',lw,...
      'Erasemode',em,...
      'Color',yc,...
      'HandleVisibility','callback',...
      'ButtonDownFcn',cb,...
      'UserData',4);
   MMPROBE_.H(4,2)=text('Position',[xm Y12(2)],...
      'Erasemode',em,...
      'FontUnits',fu,...
      'Fontsize',fs,...
      'HorizontalAlignment','left',...
      'VerticalAlignment','bottom',...
      'Color',yc,...
      'HandleVisibility','on',...
      'String',sprintf('%.0f',xym(4)),...
      'ButtonDownFcn','mmprobe editline',...
      'UserData',4);
   
   apos=mmgetpos(Ha,'pixels');
   asiz=mmgetsiz(Ha,'pixels');
   apos=[apos(1) (apos(2)-asiz-30) apos(3) asiz+10];
   MMPROBE_.X=uicontrol(Hf,'Style','text',...
      'units','pixels',...
      'Position',apos,...
      'FontName',fn,...
      'FontUnits',fu,...
      'FontSize',fs,...
      'HandleVisibility','callback',...
      'BackGroundColor',get(Hf,'Color'),...
      'ForeGroundColor',xc,...
      'HorizontalAlignment','center');
   figure(Hf)
   mmprobe updatedata
   
case 'editline' % possible double click editing of marker positions
   % 		Ht=gcbo
   % 		get(Ht,'type')
   % 		set(Ht,'Editing','on')
   % 		str=get(Ht,'string')
   % 		num=get(Ht,'UserData')
   
case 'lrdrag' % move vertical marker line -------------------------
   num=get(gco,'UserData');
   [Hf,p,Xl]=mmget(MMPROBE_.Ha,'Parent','CurrentPoint','Xlim');
   xx=p(:,1);
   p=p(1,1);
   [x1,x2]=mmget(MMPROBE_.H(1:2,1),'Xdata');
   if p>Xl(1) & p<Xl(2)
      set(MMPROBE_.H(num,1),'Xdata',xx)
      tp=get(MMPROBE_.H(num,2),'Position');
      set(MMPROBE_.H(num,2),'Position',[p tp(2)],...
         'String',sprintf('%.0f',mmlog10(p)*1e2))
   end
   if ~strcmp(get(Hf,'SelectionType'),'normal') % move both lines
      dx=x2-x1;
      if num==2
         num=1;
         xx=xx(:)-dx(:);
      else
         num=2;
         xx=xx(:)+dx(:);
      end
      p=xx(1);
      if p>Xl(1) & p<Xl(2)
         set(MMPROBE_.H(num,1),'Xdata',xx)
         tp=get(MMPROBE_.H(num,2),'Position');
         set(MMPROBE_.H(num,2),'Position',[p tp(2)],...
            'String',sprintf('%.0f',mmlog10(p)*1e2))
      end
   end
   mmprobe updatedata
   
case 'uddrag' % move horizontal marker line -----------------------
   num=get(gco,'UserData');
   [Hf,p,Yl]=mmget(MMPROBE_.Ha,'Parent','CurrentPoint','Ylim');
   yy=p(:,2);
   p=p(1,2);
   [y1,y2]=mmget(MMPROBE_.H(3:4,1),'Ydata');
   
   if p>Yl(1) & p<Yl(2)
      set(MMPROBE_.H(num,1),'Ydata',yy)
      tp=get(MMPROBE_.H(num,2),'Position');
      set(MMPROBE_.H(num,2),'Position',[tp(1) p],...
         'String',sprintf('%.0f',mmlog10(p)*1e2))
   end
   if ~strcmp(get(Hf,'SelectionType'),'normal') % move both lines
      dy=y2-y1;
      if num==3
         num=4;
         yy=yy(:)+dy(:);
      else
         num=3;
         yy=yy(:)-dy(:);
      end
      p=yy(1);
      if p>Yl(1) & p<Yl(2)
         set(MMPROBE_.H(num,1),'Ydata',yy)
         tp=get(MMPROBE_.H(num,2),'Position');
         set(MMPROBE_.H(num,2),'Position',[tp(1) p],...
            'String',sprintf('%.0f',mmlog10(p)*1e2))
      end
   end
   mmprobe updatedata
   
case 'updatedata' % update marker data ---------------------------
   dx=abs(get(MMPROBE_.H(2,1),'Xdata')-get(MMPROBE_.H(1,1),'Xdata'));
   dx=max(dx(1),eps);f=1/dx;
   dy=max(abs(get(MMPROBE_.H(4,1),'Ydata')-get(MMPROBE_.H(3,1),'Ydata')));
   dydx=dy/dx;
   d=sqrt(dy^2+dx^2);
   a=atan(dydx)*180/pi;
   s='dX=%.3g  dY=%.3g  dY/dX=%.3g   1/dX=%.3g  Diag=%.3g  Angle=%.1f';
   set(MMPROBE_.X,'String',sprintf(s,dx,dy,dydx,f,d,a),...
      'UserData',[double('M') dx dy dydx f d a],'Visible','on')
   set(MMPROBE_.Hxl,'Visible','off')
   
case 'restart' %----------------------------------------------------
   
   [xl,yl,xdir,ydir]=mmget(gca,'Xlim','Ylim','Xdir','Ydir');
   dx=xl(2)-xl(1);
   X12=[1 9]/10*dx+xl(1);
   xm=xl(1)+dx/100;
   if strcmp(xdir,'reverse')
      xm=xl(2)-dx/100;
   end
   dy=yl(2)-yl(1);
   Y12=[1 9]/10*dy+yl(1);
   ym=yl(1);
   if strcmp(ydir,'reverse')
      ym=yl(2);
   end
   xym=mmlog10([X12 Y12])*1e2;
   set(MMPROBE_.H(1,1),'Xdata',[1 1]*X12(1),'Ydata',yl)
   set(MMPROBE_.H(1,2),'Position',[X12(1) ym],'String',sprintf('%.0f',xym(1)));
   
   set(MMPROBE_.H(2,1),'Xdata',[1 1]*X12(2),'Ydata',yl);
   set(MMPROBE_.H(2,2),'Position',[X12(2) ym],'String',sprintf('%.0f',xym(2)));
   
   set(MMPROBE_.H(3,1),'Xdata',xl,'Ydata',[1 1]*Y12(1));
   set(MMPROBE_.H(3,2),'Position',[xm Y12(1)],'String',sprintf('%.0f',xym(3)));
   
   set(MMPROBE_.H(4,1),'Xdata',xl,'Ydata',[1 1]*Y12(2));
   set(MMPROBE_.H(4,2),'Position',[xm Y12(2)],'String',sprintf('%.0f',xym(4)));
   
   mmprobe updatedata
   
case 'keypress' % key press over figure -----------------------------
   
   k=lower(get(gcf,'CurrentCharacter'));
   switch k
   case {'/' '?'} % show help window
      helpwin mmprobe
      figure(gcf)
   case 'g' % toggle grid
      grid
   case ' ' % get marker line positions
      pr={'Vertical Marker 1','Vertical Marker 2',...
            'Horizontal Marker 1','Horizontal Marker 2'};
      prtitle='Choose Marker Positions';
      [v1,v2]=mmget(MMPROBE_.H(1:2,1),'Xdata');
      [h1,h2]=mmget(MMPROBE_.H(3:4,1),'Ydata');
      
      prdef={mmprintf(v1(1)) mmprintf(v2(1)) mmprintf(h1(1)) mmprintf(h2(1))};
      prans=inputdlg(pr,prtitle,1,prdef);
      if ~isempty(prans)
         v1=eval(prans{1},prdef{1});
         v2=eval(prans{2},prdef{2});
         h1=eval(prans{3},prdef{3});
         h2=eval(prans{4},prdef{4});
         [Xl,Yl]=mmget(MMPROBE_.Ha,'Xlim','Ylim');
         
         if v1>Xl(1) & v1<Xl(2)
            set(MMPROBE_.H(1,1),'Xdata',[v1;v1])
            tp=get(MMPROBE_.H(1,2),'Position');
            set(MMPROBE_.H(1,2),'Position',[v1 tp(2)],...
               'String',sprintf('%.0f',mmlog10(v1)*1e2))
         end
         if v2>Xl(1) & v2<Xl(2)
            set(MMPROBE_.H(2,1),'Xdata',[v2;v2])
            tp=get(MMPROBE_.H(2,2),'Position');
            set(MMPROBE_.H(2,2),'Position',[v2 tp(2)],...
               'String',sprintf('%.0f',mmlog10(v2)*1e2))
         end
         if h1>Yl(1) & h1<Yl(2)
            set(MMPROBE_.H(3,1),'Ydata',[h1;h1])
            tp=get(MMPROBE_.H(3,2),'Position');
            set(MMPROBE_.H(3,2),'Position',[tp(1) h1],...
               'String',sprintf('%.0f',mmlog10(h1)*1e2))
         end
         if h2>Yl(1) & h2<Yl(2)
            set(MMPROBE_.H(4,1),'Ydata',[h2;h2])
            tp=get(MMPROBE_.H(4,2),'Position');
            set(MMPROBE_.H(4,2),'Position',[tp(1) h2],...
               'String',sprintf('%.0f',mmlog10(h2)*1e2))
         end
         mmprobe updatedata
      end
   case 'z' % zoom in or find zero crossing
      Hl=findobj(MMPROBE_.Ha,'Type','line','Tag','MMPROBE_i');
      if ~isempty(Hl) % find nearest zero crossing
         [C,xd,yd]=mmget(Hl,'Color','Xdata','Ydata');
         xp=get(findobj(MMPROBE_.Ha,'Tag','MMPROBE_P'),'Xdata');
         x1=mmsearch(yd,xd,0);
         if ~isempty(x1)
            [x,idx]=min(abs(x1-xp));
            x1=x1(idx);
            [x,y,yp]=mmgetpt([x1 0],xd,yd);
            xy=[x,0,yp,atan(yp)*180/pi];
            
            [xl,yl]=mmget(MMPROBE_.Ha,'Xlim','Ylim');
            sx=xl(:);       % find line thru point at computed slope
            sy=yp*(sx-x)+y;
            if sy(1)<yl(1)  % clip at ymin
               sy(1)=yl(1);
               sx(1)=x+(yl(1)-y)/yp;
            end
            if sy(2)>yl(2)  % clip at ymax
               sy(2)=yl(2);
               sx(2)=x+(yl(2)-y)/yp;
            end
            Hp=findobj(MMPROBE_.Ha,'Tag','MMPROBE_P');
            Hs=findobj(MMPROBE_.Ha,'Tag','MMPROBE_S');
            set(Hp,'Xdata',xy(1),'Ydata',xy(2),'Color',C,'Visible','on')
            set(Hs,'Xdata',sx,'Ydata',sy,...
               'Color',C,'LineStyle',':','Marker','None')
            s=sprintf('X=%.3g  Y=%.3g   dY/dX=%.3g  Angle=%.1f',xy);
            set(MMPROBE_.X,'String',s,...
               'UserData',[double('I') xy],...
               'Visible','on')
            set(MMPROBE_.Hxl,'Visible','off')
         end
      else % zoom in
         x=[get(MMPROBE_.H(1,1),'Xdata') get(MMPROBE_.H(2,1),'Xdata')];
         y=[get(MMPROBE_.H(3,1),'Ydata') get(MMPROBE_.H(4,1),'Ydata')];
         set(MMPROBE_.Ha,'Xlim',[min(x) max(x)],...
            'Ylim',[min(y) max(y)])
         mmprobe restart
      end
   case 'x'  % zoom in x-axis only
      x=[get(MMPROBE_.H(1,1),'Xdata') get(MMPROBE_.H(2,1),'Xdata')];
      set(MMPROBE_.Ha,'Xlim',[min(x) max(x)],'YlimMode','manual')
      mmprobe restart
   case 'y'  % zoom in y-axis only
      y=[get(MMPROBE_.H(3,1),'Ydata') get(MMPROBE_.H(4,1),'Ydata')];
      set(MMPROBE_.Ha,'Ylim',[min(y) max(y)],'XlimMode','manual')
      mmprobe restart
   case 'o'  % zoom out
      set(MMPROBE_.Ha,'Xlim',MMPROBE_.Alim(1:2),'Ylim',MMPROBE_.Alim(3:4),...
         'XlimMode',MMPROBE_.Xmode,'YlimMode',MMPROBE_.Ymode)
      mmprobe restart
   case 'd'  % delete marked point
      set(findobj(MMPROBE_.Ha,'Tag','MMPROBE_P'),'Visible','off');
      set(findobj(MMPROBE_.Ha,'Tag','MMPROBE_S'),'Visible','off');
      set(findobj(MMPROBE_.Ha,'Type','line','Tag','MMPROBE_i'),'Tag','');
   case 'h'  % move horizontal markers
      Hl=findobj(MMPROBE_.Ha,'Type','line','Tag','MMPROBE_i');
      if ~isempty(Hl)
         [xd,yd]=mmget(Hl,'Xdata','Ydata');
         [x1,x2]=mmget(MMPROBE_.H(1:2,1),'Xdata');
         y1=mminterp(xd,yd,x1(1));
         y2=mminterp(xd,yd,x2(1));
         if ~isnan(y1) & ~isnan(y2)
            set(MMPROBE_.H(3,1),'Ydata',[y1 y1])
            tp=get(MMPROBE_.H(3,2),'Position');
            set(MMPROBE_.H(3,2),'Position',[tp(1) y1],...
               'String',sprintf('%.0f',mmlog10(y1)*1e2))
            set(MMPROBE_.H(4,1),'Ydata',[1 1]*y2)
            tp=get(MMPROBE_.H(4,2),'Position');
            set(MMPROBE_.H(4,2),'Position',[tp(1) y2],...
               'String',sprintf('%.0f',mmlog10(y2)*1e2))
            mmprobe updatedata
         end
      end
   case 'v' % move vertical markers
      Hl=findobj(MMPROBE_.Ha,'Type','line','Tag','MMPROBE_i');
      if ~isempty(Hl)
         [xd,yd]=mmget(Hl,'Xdata','Ydata');
         [y1,y2]=mmget(MMPROBE_.H(3:4,1),'Ydata');
         x1=mmsearch(yd,xd,y1(1));
         x2=mmsearch(yd,xd,y2(1));
         if ~isempty(x1) & ~isempty(x2)
            xp=get(findobj(MMPROBE_.Ha,'Tag','MMPROBE_P'),'Xdata');
            [x,idx]=min(abs(x1-xp));
            x1=x1(idx);
            [x,idx]=min(abs(x2-xp));
            x2=x2(idx);
            x=min(x1,x2);
            set(MMPROBE_.H(1,1),'Xdata',[1 1]*x)
            tp=get(MMPROBE_.H(1,2),'Position');
            set(MMPROBE_.H(1,2),'Position',[x tp(2)],...
               'String',sprintf('%.0f',mmlog10(x)*1e2))
            x=max(x1,x2);
            set(MMPROBE_.H(2,1),'Xdata',[x x])
            tp=get(MMPROBE_.H(2,2),'Position');
            set(MMPROBE_.H(2,2),'Position',[x tp(2)],...
               'String',sprintf('%.0f',mmlog10(x)*1e2))
            mmprobe updatedata
         end
      end
   case 'm' % move marker lines to marked point
      Hl=findobj(MMPROBE_.Ha,'Type','line','Tag','MMPROBE_i');
      if ~isempty(Hl)
         Hp=findobj(MMPROBE_.Ha,'Tag','MMPROBE_P');
         [xd,yd]=mmget(Hp,'Xdata','Ydata');
         x1=get(MMPROBE_.H(1,1),'Xdata');
         x2=get(MMPROBE_.H(2,1),'Xdata');
         [tmp,idx]=min(abs([x1(1) x2(1)]-xd));
         set(MMPROBE_.H(idx,1),'Xdata',[xd xd])
         tp=get(MMPROBE_.H(idx,2),'Position');
         set(MMPROBE_.H(idx,2),'Position',[xd tp(2)],...
            'String',sprintf('%.0f',mmlog10(xd)*1e2))
         y1=get(MMPROBE_.H(3,1),'Ydata');
         y2=get(MMPROBE_.H(4,1),'Ydata');
         [tmp,idx]=min(abs([y1(1) y2(1)]-yd));
         idx=idx+2;
         set(MMPROBE_.H(idx,1),'Ydata',[yd yd])
         tp=get(MMPROBE_.H(idx,2),'Position');
         set(MMPROBE_.H(idx,2),'Position',[tp(1) yd],...
            'String',sprintf('%.0f',mmlog10(yd)*1e2))
         mmprobe updatedata
      end
   case {',' '<' '.' '>'} % find extremes
      Hl=findobj(MMPROBE_.Ha,'Type','line','Tag','MMPROBE_i');
      if ~isempty(Hl)
         [C,xd,yd]=mmget(Hl,'Color','Xdata','Ydata');
         xlen=length(xd);
         Hp=findobj(MMPROBE_.Ha,'Tag','MMPROBE_P');
         Hs=findobj(MMPROBE_.Ha,'Tag','MMPROBE_S');
         xl=get(MMPROBE_.Ha,'Xlim');
         idx=find(xd>=min(xl)&xd<=max(xl));
         xd=xd(idx); yd=yd(idx);
         [x,y]=mmget(Hp,'Xdata','Ydata');
         imm=mmpeaks(yd,'all');
         switch k
         case ','
            imm=imm(2:end-1);
            idx=find(xd(imm)<(x-abs(diff(xl)/100)));
            if ~isempty(idx)
               idx=imm(idx(end));
               if idx==1,        idx=[1 2 3];
               elseif idx==xlen, idx=xlen-[0 1 2];
               else              idx=idx+[-1 0 1];
               end
               p=polyfit(xd(idx),yd(idx),2);
               x=-p(2)/(2*p(1)); % zero slope point
               y=(p(1)*x+p(2))*x+p(3);
               set(Hp,'Xdata',x,'Ydata',y,'Color',C)
               set(Hs,'Xdata',xl,'Ydata',[y y],...
                  'Color',C,'LineStyle',':','Visible','on')		
               s=sprintf('Interpolated Zero Slope Point:  X=%.4g  Y=%.4g',x,y);
               set(MMPROBE_.X,'String',s,...
                  'UserData',[double('I') x y 0 0],...
                  'Visible','on')
               set(MMPROBE_.Hxl,'Visible','off')
            end
         case '.'
            imm=imm(2:end-1);
            idx=find(xd(imm)>(x+abs(diff(xl)/100)));
            if ~isempty(idx)
               idx=imm(idx(1));
               if idx==1,        idx=[1 2 3];
               elseif idx==xlen, idx=xlen-[0 1 2];
               else              idx=idx+[-1 0 1];
               end
               p=polyfit(xd(idx),yd(idx),2);
               x=-p(2)/(2*p(1)); % zero slope point
               y=(p(1)*x+p(2))*x+p(3);
               set(Hp,'Xdata',x,'Ydata',y,'Color',C)
               set(Hs,'Xdata',xl,'Ydata',[y y],...
                  'Color',C,'LineStyle',':','Visible','on')		
               s=sprintf('Interpolated Zero Slope Point:  X=%.4g  Y=%.4g',x,y);
               set(MMPROBE_.X,'String',s,...
                  'UserData',[double('I') x y 0 0],...
                  'Visible','on')
               set(MMPROBE_.Hxl,'Visible','off')
            end			
         case '<'
            idx=find(xd(imm)<(x-abs(diff(xl)/100)));
            if ~isempty(idx)
               idx=imm(idx(end));
               set(Hp,'Xdata',xd(idx),'Ydata',yd(idx),'Color',C)
               set(Hs,'Visible','off')	
               s=sprintf('Raw Data at Extreme:  X=%.4g  Y=%.4g',xd(idx),yd(idx));
               set(MMPROBE_.X,'String',s,...
                  'UserData',[double('I') xd(idx) yd(idx) nan nan],...
                  'Visible','on')
               set(MMPROBE_.Hxl,'Visible','off')
            end
         case '>'
            idx=find(xd(imm)>(x+abs(diff(xl)/100)));
            if ~isempty(idx)
               idx=imm(idx(1));
               set(Hp,'Xdata',xd(idx),'Ydata',yd(idx),'Color',C)
               set(Hs,'Visible','off')		
               s=sprintf('Raw Data at Extreme:  X=%.4g  Y=%.4g',xd(idx),yd(idx));
               set(MMPROBE_.X,'String',s,...
                  'UserData',[double('I') xd(idx) yd(idx) nan nan],...
                  'Visible','on')
               set(MMPROBE_.Hxl,'Visible','off')
            end			
         end % case
      end % if ~isempty
   case 'i' % interpolate selected line
      Hl=findobj(MMPROBE_.Ha,'Type','line','Tag','MMPROBE_i');
      if ~isempty(Hl)
         Hp=findobj(MMPROBE_.Ha,'Tag','MMPROBE_P');
         xp=get(Hp,'Xdata');
         pr={'X Data Value'};
         prtitle='Interpolate Line';
         prdef={mmprintf(xp)};
         prans=inputdlg(pr,prtitle,1,prdef);
         if isempty(prans)
            x=prdef{1};
         else
            x=eval(prans{1},prdef{1});
         end
         [xlim,ylim]=mmget(MMPROBE_.Ha,'Xlim','Ylim');
         if x>=xlim(1) & x<=xlim(2)
            [C,xd,yd]=mmget(Hl,'Color','Xdata','Ydata');
            [x,y,yp]=mmgetpt([x 0],xd,yd);
            xy=[x,y,yp,atan(yp)*180/pi];
            
            sx=xlim(:);       % find line thru point at computed slope
            sy=yp*(sx-x)+y;
            if sy(1)<ylim(1)  % clip at ymin
               sy(1)=ylim(1);
               sx(1)=x+(ylim(1)-y)/yp;
            end
            if sy(2)>ylim(2)  % clip at ymax
               sy(2)=ylim(2);
               sx(2)=x+(ylim(2)-y)/yp;
            end
            Hs=findobj(MMPROBE_.Ha,'Tag','MMPROBE_S');
            set(Hp,'Xdata',xy(1),'Ydata',xy(2),'Color',C,'Visible','on')
            set(Hs,'Xdata',sx,'Ydata',sy,...
               'Color',C,'LineStyle',':','Marker','None')
            s=sprintf('X=%.3g  Y=%.3g   dY/dX=%.3g  Angle=%.1f',xy);
            set(MMPROBE_.X,'String',s,...
               'UserData',[double('I') xy],...
               'Visible','on')
            set(MMPROBE_.Hxl,'Visible','off')
         end
      end
   case {'0' '1' '2' '3' '4' '5'} % find polynomial
      n=sscanf(k,'%d',1);
      Hl=findobj(MMPROBE_.Ha,'Type','line','Tag','MMPROBE_i');
      if ~isempty(Hl)
         [xd,yd]=mmget(Hl,'Xdata','Ydata');
         [x1,x2]=mmget(MMPROBE_.H([1:2],1),'Xdata');
         idx=find(xd>=x1(1) & xd<=x2(1));
         if length(idx>n)
            xp=xd(idx);
            p=polyfit(xp,yd(idx),n);
            yp=polyval(p,xp);
            err=norm(yp-yd(idx),inf);
            Hs=findobj(MMPROBE_.Ha,'Tag','MMPROBE_S');
            set(Hs,'Xdata',xp,'Ydata',yp,'Marker','d','visible','on')
            s=[ sprintf('||e|| = %.3g',err) ',  P(x) = ' mmp2str(p)];
            set(MMPROBE_.X,'String',s,...
               'UserData',[double('P') p],...
               'Visible','on')
            set(MMPROBE_.Hxl,'Visible','off')
            Hp=findobj(MMPROBE_.Ha,'Tag','MMPROBE_P');
            set(Hp,'Visible','off')
         end			
      end
   case 's'  % save data or polynomial to Command Window
      s=get(MMPROBE_.X,'UserData');
      str=char(s(1));
      s=s(2:end);
      switch str
      case 'P'
         t=evalin('base','exist(''PROBE_P'',''var'')');
         if t
            t=evalin('base','PROBE_P');
            assignin('base','PROBE_P',mmp2pm(t,s))
         else
            assignin('base','PROBE_P',s)
         end
      case 'I'
         t=evalin('base','exist(''PROBE_I'',''var'')');
         if t
            t=evalin('base','PROBE_I');
            assignin('base','PROBE_I',[t;s])				
         else
            assignin('base','PROBE_I',s)
         end	
      case 'M'
         t=evalin('base','exist(''PROBE_M'',''var'')');
         if t
            t=evalin('base','PROBE_M');
            assignin('base','PROBE_M',[t;s])				
         else
            assignin('base','PROBE_M',s)
         end
      end
   end
   
case 'interpolate' % interpolate plotted data ------------------------------
   Hl=gco;
   if strcmp(get(Hl,'Tag'),'MMPROBE_P') | strcmp(get(Hl,'Tag'),'MMPROBE_S')
      Hl=findobj(MMPROBE_.Ha,'Tag','MMPROBE_i');
   end
   [Hf,xy,xl,yl]=mmget(MMPROBE_.Ha,'Parent','CurrentPoint','Xlim','Ylim');
   v='on';
   if strcmp(get(Hf,'SelectionType'),'normal')
      v='off';
   end
   
   set(Hf,'Pointer','circle')
   [C,xdata,ydata]=mmget(Hl,'Color','Xdata','Ydata');
   set(findobj(MMPROBE_.Ha,'Tag','MMPROBE_i'),'Tag','');
   set(Hl,'Tag','MMPROBE_i')
   
   [x,y,yp]=mmgetpt(xy(1,1:2),xdata,ydata);
   xy=[x,y,yp,atan(yp)*180/pi];
   
   sx=xl(:);       % find line thru point at computed slope
   sy=yp*(sx-x)+y;
   if sy(1)<yl(1)  % clip at ymin
      sy(1)=yl(1);
      sx(1)=x+(yl(1)-y)/yp;
   end
   if sy(2)>yl(2)  % clip at ymax
      sy(2)=yl(2);
      sx(2)=x+(yl(2)-y)/yp;
   end
   
   Hp=findobj(MMPROBE_.Ha,'Tag','MMPROBE_P');
   if isempty(Hp) % identify current point
      Hs=line('Xdata',sx,'Ydata',sy,...
         'EraseMode','xor',...
         'LineStyle',':',...
         'Color',C,...
         'HandleVisibility','callback',...
         'Tag','MMPROBE_S',...
         'Visible',v,...
         'ButtonDownFcn',...
         'set(gcf,''WindowButtonMotionFcn'',''mmprobe interpolate'')');
      Hp=line('Xdata',xy(1),'Ydata',xy(2),...
         'EraseMode','xor',...
         'MarkerSize',8,...
         'Marker','o',...
         'Color',C,...
         'HandleVisibility','callback',...
         'Tag','MMPROBE_P',...
         'ButtonDownFcn',...
         'set(gcf,''WindowButtonMotionFcn'',''mmprobe interpolate'')');
   else  % move to current point
      Hs=findobj(MMPROBE_.Ha,'Tag','MMPROBE_S');
      set(Hp,'Xdata',xy(1),'Ydata',xy(2),'Color',C,'Visible','on')
      set(Hs,'Xdata',sx,'Ydata',sy,...
         'Color',C,'LineStyle',':','Visible',v,'Marker','None')
   end
   s=sprintf('X=%.3g  Y=%.3g   dY/dX=%.3g  Angle=%.1f',xy);
   set(MMPROBE_.X,'String',s,...
      'UserData',[double('I') xy],...
      'Visible','on')
   set(MMPROBE_.Hxl,'Visible','off')
   
case 'reset' % reset on button up ---------------------------------------------
   Hf=gcf;
   set(Hf,'WindowButtonMotionFcn','','Pointer','arrow')
   set(MMPROBE_.Hxl,'String',get(MMPROBE_.X,'String'),'Visible','on')
   set(MMPROBE_.X,'Visible','off')
   refresh(Hf)
   
case 'off' % turn mmprobe off -------------------------------------------------
   if ~isempty(MMPROBE_)  % off request
      set(findobj(MMPROBE_.Ha,'Type','line'),'ButtonDownFcn','');
      set(findobj(MMPROBE_.Ha,'Tag','MMPROBE_i'),'Tag','');
      delete(MMPROBE_.H)
      delete(MMPROBE_.X)
      set(get(MMPROBE_.Ha,'Parent'),'WindowButtonUpFcn','',...
         'ButtonDownFcn','',...
         'BackingStore','on',...
         'Pointer','arrow',...
         'KeyPressFcn','')
      delete(findobj(MMPROBE_.Ha,'Tag','MMPROBE_P'));
      delete(findobj(MMPROBE_.Ha,'Tag','MMPROBE_S'));
      set(findobj('Tag','MMPROBE'),'Tag','')
      set(MMPROBE_.Hxl,'String',MMPROBE_.Xls,'Visible','on')
      clear global MMPROBE_
   end
otherwise
   disp('MMPROBE: Unknown Input.')
end
