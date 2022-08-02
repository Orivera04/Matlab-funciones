function H=mmarrow(x,y,varargin)
%MMARROW Plot Moveable Arrows on Current Linear 2D Axes. (MM)
% Hr=MMARROW(X,Y,'Name','Value',...) plots arrows on the current 2D plot where:
% X,Y are vectors of x- and y-axis arrow tip coordinates respectively, and
% other arrow properties are set by the property name-value pairs:
% NAME     {default} DESCRIPTION
% 'Angle'      {0}   scalar or vector of angles in degrees w.r.t. the SCREEN!
% 'Tail'      {40}   scalar or vector of arrow tail lengths in POINTS.
% 'TipLength' {10}   scalar or vector of arrow tip lengths in POINTS.
% 'TipWidth'   {8}   scalar or vector of arrow tip widths in POINTS.
% 'Color'     {get(gca,'Xcolor')} arrow colorspecs
%                                 scalar or vector of {c m y r g b w k} or an
%                                 RGB matrix having one or length(X) rows.
% 'Type'   {'line'} graphics object used to draw arrows:
%                    'line'  object arrows have hollow tips.
%                    'patch' object arrows have solid tips.
% 'Drag'    {'off'} enable mouse dragging and reshaping: 'on' or 'off'
%
% Hr=MMARROW('Name','Value',...) also works. In this case, 'Xdata',X and
%'Ydata',Y are also property name-value pairs. If 'Xdata' and 'Ydata'
% are not specified, one arrow is placed at the center of the current plot.
%
% If X and Y are vectors, scalar property values apply to all arrows.
% If Hr is present, it contains a vector of line or patch handles.
%
% MMARROW with no arguments places one default arrow in the center of the
% current plot and enables dragging and reshaping.
% MMARROW(N) places N default arrows in the center of the current plot and
% enables dragging and reshaping.
% 
% MMARROW on (off) enables (disables) dragging and reshaping of an arrow
% with the mouse. Normal mouse selection drags the arrow;
% Right mouse button or Shift-mouse button on the Mac, moves the arrow
% tail to the mouse position but leaves the arrow tip fixed.
% Clicking on an open area of the figure window outside the plot
% also disables dragging and reshaping.

% Calls: mmgcf mmgca mmrgb mmgetpos mmonoff mmis2d

% D.C. Hanselman, University of Maine, Orono, ME, 04469
% 10/28/96, revised 12/17/96, v5: 2/26/97, 9/2/97, 9/10/97
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if nargin==0  % create one default arrow
   Hr=mmarrow(1);
   if nargout, H=Hr; end
elseif nargin==1 & isnumeric(x) & x>0 % MMARROW(N)
   Hf=mmgcf(1);
   Ha=mmgca(Hf,1);
   [xs,ys,xlim,ylim]=mmget(Ha,'Xscale','Yscale','Xlim','Ylim');
   if ~mmis2d(Ha)
      error('View must be 2D.')  % abort since not 2-D on x-y plane
   end
   if strcmp(xs,'log')|strcmp(ys,'log')
      error('X and Y Must be Linear Axes.')
   end
   xp=sum(xlim)/2;
   yp=sum(ylim)/2;
   x=min(x,36);
   a=linspace(0,360,x+1)';
   Hr=mmarrow(repmat(xp,x,1),repmat(yp,x,1),'Angle',a(1:x));
   if nargout, H=Hr; end
   mmarrow('on')
   
elseif nargin>=2  % create arrows using input arguments
   Hf=mmgcf(1);
   Ha=mmgca(Hf,1);
   if ~mmis2d(Ha)
      error('Axis Must be 2D.')
   end
   [xs,xlim,ys,ylim]=mmget(Ha,'Xscale','Xlim','Yscale','Ylim');
   if strcmp(xs,'log')|strcmp(ys,'log')
      error('X and Y Must be Linear Axes.')
   end
   
   if rem(nargin,2) % odd number of input arguments
      error('Not Enough Input Arguments: Names and Values Must Appear in Pairs.')
   end
   if ischar(x) % MMARROW('Name','Value',...)
      inargs={x y varargin{:}};
      nargs=length(inargs);
      x=sum(xlim)/2; xlen=1;
      y=sum(ylim)/2; ylen=1;
   else         % MMARROW(X,Y,'Name','Value',...)	
      xlen=length(x); ylen=length(y);
      if xlen~=ylen, error('X and Y Must be the Same Length.'), end
      inargs=varargin;
      nargs=nargin-2;
   end
   
   ang=0; ll=40; tl=10; tw=8; col=get(Ha,'Xcolor'); sty='line';
   cdef=col; drag=0;
   
   for i=1:2:nargs-1
      name=lower(inargs{i});
      if ~ischar(name)
         error('Property Names Must be Strings.')
      end
      value=inargs{i+1};
      if strncmp(name,'a',1)
         ang=value;
      elseif strncmp(name,'ta',2)
         ll=value;
      elseif strncmp(name,'tipw',4)
         tw=value;
      elseif strncmp(name,'tipl',4)
         tl=value;
      elseif strncmp(name,'c',1)
         col=value;
         if ischar(col), col=col(:); end
      elseif strncmp(name,'ty',2)
         sty=value;
      elseif strncmp(name,'d',1)
         drag=mmonoff(value);
         if isempty(drag)
            error('Value Must Be ''on'' or ''off''.')
         end
      elseif strncmp(name,'x',1)
         x=value;
      elseif strncmp(name,'y',1)
         y=value;
      else
         error(['Unknown Property Name: ' name])
      end
   end
   ang=ang*pi/180;
   anglen=length(ang);
   llen=length(ll);
   twlen=length(tw);
   tllen=length(tl);
   colen=size(col,1);
   
   [xlim,ylim]=mmget(Ha,'Xlim','Ylim');
   apos=mmgetpos(Ha,'Points');
   dx=abs(xlim(2)-xlim(1))/apos(3);  % ratio of x-data to points
   dy=abs(ylim(2)-ylim(1))/apos(4);  % ratio of y-data to points
   
   Hr=zeros(xlen,1);
   
   for i=1:xlen  % generate arrows
      a=min(i,anglen); l=min(i,llen);
      w=min(i,twlen); t=min(i,tllen); c=min(i,colen);
      xap=[-ll(l)-tl(t) -tl(t)  -tl(t)    0  -tl(t)   -tl(t) -ll(l)-tl(t)]';% initial arrow
      yap=[ 0             0      tw(w)/2  0  -tw(w)/2    0        0      ]';
      dap=[dx             dy     ang(a)   0      0       0        0      ]';
      [th,r]=cart2pol(xap,yap);    % to polar
      [xa,ya]=pol2cart(th+ang(a),r); % add angle, then back to Cartesian.
      xa=xa*dx+x(i);               % convert points to data coordinates	
      ya=ya*dy+y(i);               % and shift to given data points
      c=mmrgb(col(c,:),cdef);
      
      if strncmp(sty,'p',1) % create patch arrow
         Hr(i)=patch('Xdata',xa,'Ydata',ya,...
            'EdgeColor',c,...
            'FaceColor',c,...
            'Tag','MMARROW',...
            'UserData',[xap yap dap]);
      else
         Hr(i)=line('Xdata',xa,'Ydata',ya,...
            'Color',c,...
            'Tag','MMARROW',...
            'UserData',[xap yap dap]);
      end
   end
   if drag, mmarrow('on'), end
   if nargout, H=Hr; end
   
elseif nargin==1 & ischar(x)  % MMARROW ON or OFF
   set(0,'ShowHiddenHandles','on')
   Hr=findobj(0,'Tag','MMARROW');
   set(0,'ShowHiddenHandles','off')
   if isempty(Hr), error('No Arrows Exists.'), end
   Hf=get(get(Hr(1),'Parent'),'Parent');
   if mmonoff(x)
      set(Hr,'ButtonDownFcn','mmarrow(-1)')
      set(Hf,'ButtonDownFcn','mmarrow(''off'')')
   else
      set(Hr,'ButtonDownFcn','')
      set(Hf,'ButtonDownFcn','')
   end
elseif nargin==1 % callbacks
   if x==-1 % button down callback
      Hf=gcf;
      [Ha,Hr,Stype]=mmget(Hf,'CurrentAxes','CurrentObject','SelectionType');
      cp=get(Ha,'CurrentPoint');
      [xa,ya]=mmget(Hr,'Xdata','Ydata');
      if strcmp(Stype,'normal') % drag arrow
         cbstr='mmarrow(-2)';
         ptr='circle';
      else                      % reshape arrow
         cbstr='mmarrow(-3)';
         ptr='crosshair';
      end
      text('String',sprintf('(%.2g,%.2g)',0,0),...
         'Position',[0,0],...
         'EraseMode','xor',...
         'FontSize',10,...
         'Tag','MMARROW_T',...
         'Visible','off');
      set(Hf,'WindowButtonMotionFcn',cbstr,...
         'WindowButtonUpFcn','mmarrow(-99)',...
         'Pointer',ptr)
      set(Hr,'EraseMode','xor')
      
   elseif x==-2  % normal motion callback (drag arrow)
      Hf=gcf;
      [Ha,Hr]=mmget(Hf,'CurrentAxes','CurrentObject');
      cp=get(Ha,'CurrentPoint');
      [xa,ya,da]=mmget(Hr,'Xdata','Ydata','UserData');
      a=da(3,3);
      set(Hr,'Xdata',xa-xa(4)+cp(1,1),...
         'Ydata',ya-ya(4)+cp(1,2))
      Ht=findobj(Ha,'Tag','MMARROW_T');
      set(Ht,'Position',cp(1,1:2),'Visible','on',...
         'String',sprintf('   (X=%.3g, Y=%.3g)   ',cp(1,1:2)))
      if abs(a)<pi/4, set(Ht,'HorizontalAlignment','right')
      else,           set(Ht,'HorizontalAlignment','left')
      end
      if a>0, set(Ht,'VerticalAlignment','bottom')
      else,   set(Ht,'VerticalAlignment','top')
      end
      
   elseif x==-3  % NOT normal motion callback (reshape arrow)
      Hf=gcf;
      [Ha,Hr]=mmget(Hf,'CurrentAxes','CurrentObject');
      cp=get(Ha,'CurrentPoint');
      [xa,ya,da]=mmget(Hr,'Xdata','Ydata','UserData');
      x=xa(4); y=ya(4);  % tip position
      [xap,yap,dap]=mmdeal(da,2);
      [dx,dy]=mmdeal(dap);
      dlx=(x-cp(1,1))/dx;        % take arrow back to points
      dly=(y-cp(1,2))/dy;
      l=round(norm([dlx dly]));
      xap(1)=-l;
      a=atan2(dly,dlx);
      da(3,3)=a;
      [th,r]=cart2pol(xap,yap);  % to polar
      [xa,ya]=pol2cart(th+a,r);  % add angle, then back to Cartesian.
      xa=xa*dx+x;                % convert points to data coordinates	
      ya=ya*dy+y;                % and shift to given data points
      set(Hr,'Xdata',xa,'Ydata',ya,'UserData',da)
      Ht=findobj(Ha,'Tag','MMARROW_T');
      set(Ht,'Position',cp(1,1:2),'Visible','on',...
         'String',sprintf('   (L=%.3g, A=%.3g)   ',l,a*180/pi))
      if abs(a)<pi/4, set(Ht,'HorizontalAlignment','left')
      else,           set(Ht,'HorizontalAlignment','right')
      end
      if a<0, set(Ht,'VerticalAlignment','bottom')
      else,   set(Ht,'VerticalAlignment','top')
      end
      
   elseif x==-99  % button up callback
      Hf=gcf;
      [Ha,Hr]=mmget(Hf,'CurrentAxes','CurrentObject');
      set(Hf,'Pointer','arrow',...
         'WindowButtonMotionFcn','',...
         'WindowButtonUpFcn','')
      set(Hr,'EraseMode','normal')
      Ht=findobj(Ha,'Tag','MMARROW_T');
      delete(Ht)
      refresh(Hf)
   end
end
