function [x,y]=mmginput(n)
%MMGINPUT Graphical Input Using Mouse. (MM)
% [X,Y]=MMGINPUT(N) gets N points from the current axes at points
% selected with a mouse button press. The N points are restricted to
% the piecewise linear interpolation of the plotted line data points.
% Striking ANY key on the keyboard aborts the process.
%
% [X,Y]=MMGINPUT gathers an arbitrary number of points until
% ANY key on the keyboard is pressed.
%
% MMGINPUT with no input or output arguments simply shows the
% coordinates of the nearest data point on the bottom of the axis
% until the mouse is clicked or a key is pressed.
%
% See also GINPUT, MMGETPT.

% Calls: mmgcf mmgca mmgetpos mmgetpt mmgetsiz mmis2d

% D.C. Hanselman, University of Maine, Orono, ME, 04469
% 10/29/96, revised 11/26/96, v5: 1/14/97
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

global MMGINPUT_X MMGINPUT_Y MMGINPUT_XL MMGINPUT_YL
global MMGINPUT_U MMGINPUT_XY MMGINPUT_P

if nargin==0 & nargout==0, n=1;
elseif nargin==0,          n=100;
end
if ~ischar(n)  % set things up to gather data
   Hf=mmgcf(1);
   Ha=mmgca(Hf,1);
   if ~mmis2d(Ha)
      error('Axis Must be 2D.')
   end
   
   MMGINPUT_XL=[]; MMGINPUT_YL=[];
   Hl=findobj(Ha,'Type','line');
   if isempty(Hl), error('No Lines in Current Axes.'),end
   for i=1:length(Hl)		% get data from lines for comparison
      xl=get(Hl(i),'Xdata');xl=xl(~isnan(xl));
      yl=get(Hl(i),'Ydata');yl=yl(~isnan(yl));
      MMGINPUT_XL=[MMGINPUT_XL;xl(:)];
      MMGINPUT_YL=[MMGINPUT_YL;yl(:)];
   end
   apos=mmgetpos(Ha,'pixels');
   asiz=mmgetsiz(Ha,'pixels');
   apos=[apos(1) (apos(2)-asiz-20) apos(3) asiz+6];
   MMGINPUT_U=uicontrol(Hf,'Style','text',...
      'units','pixels',...
      'Position',apos,...
      'FontName',get(Ha,'FontName'),...
      'FontUnits','pixels',...
      'FontSize',asiz,...
      'HorizontalAlignment','center',...
      'BackGroundColor',get(Hf,'Color'),...
      'ForeGroundColor',get(Ha,'XColor'));
   set(Hf,	'Pointer','circle',...
      'WindowButtonMotionFcn','mmginput(''m'')',...
      'WindowButtonDownFcn','mmginput(''d'')')
   figure(Hf)  % bring figure forward
   for i=1:n
      key=waitforbuttonpress; % pause until mouse is pressed
      if nargout
         x=MMGINPUT_X;
         y=MMGINPUT_Y;
      end
      if key, break, end
   end
   set(gcf,'Pointer','arrow',...
      'WindowButtonMotionFcn','',...
      'WindowButtonDownFcn','')
   delete([MMGINPUT_U;MMGINPUT_P])
   MMGINPUT_X=[]; MMGINPUT_Y=[]; MMGINPUT_XL=[]; MMGINPUT_YL=[];
   MMGINPUT_U=[]; MMGINPUT_XY=[]; MMGINPUT_P=[];
   
elseif strcmp(n,'m')  % mouse movement
   Ha=gca;
   cp=get(Ha,'CurrentPoint'); % get current mouse position
   [xc,yc]=mmgetpt(cp(1,1:2),MMGINPUT_XL,MMGINPUT_YL,0.8);
   MMGINPUT_XY=[xc,yc];
   c=(get(Ha,'XColor')+get(Ha,'YColor'))/2;
   
   if isempty(MMGINPUT_P) % identify current point
      MMGINPUT_P=line('Xdata',xc,'Ydata',yc,...
         'EraseMode','xor',...
         'MarkerSize',6,...
         'Marker','o',...
         'Color',c,...
         'Tag','point');
   else  % move to current point
      set(MMGINPUT_P,'Xdata',xc,'Ydata',yc)
   end
   xystr=sprintf('X = %.3g, Y = %.3g',xc,yc);
   set(MMGINPUT_U,'string',xystr)
   
elseif strcmp(n,'d')
   MMGINPUT_X=[MMGINPUT_X;MMGINPUT_XY(1)];  % store output data
   MMGINPUT_Y=[MMGINPUT_Y;MMGINPUT_XY(2)];
end
