function swinger(x,y,orbitval)
% SWINGER  Classic double pendulum.
%   SWINGER(x,y) starts the pendulum at the given initial position.
%   The initial position can reset with the mouse.
%
%   SWINGER with no arguments starts at (x,y) = (0.862,-0.994).
%   What is interesting about the resulting orbit?
%
%   SWINGER(0,y) with y > 2 starts in an unstable vertical position.
%   How long does it stay there and what causes it to move?
%
%   SWINGER(x,y,1) starts in "orbit" mode.
%
%   The model is a pair of coupled second order nonlinear odes for
%   two angles.  The model is rewriten as first order system involving 
%      u = [theta1, theta2, theta1dot, theta2dot]'
%   The resulting equations are in implicit form, M*udot = f.

if nargin ~= 1
   clf reset
   shg
   set(gcf,'doublebuffer','on','windowbuttonup','swinger(''click'')', ...
      'name','Swinger','numbertitle','off')
end
if nargin >= 2
   theta0 = swinginit(x,y);
elseif nargin == 1 && isequal(x,'click')
   xy = get(gca,'currentpoint');
   x = xy(1,1); y = xy(1,2);
   % If close, make it vertical.
   if abs(x) < .01 & y > 2, x = 0; y = 2; end
   theta0 = swinginit(x,y);
elseif nargin == 1 && isequal(x,'orbit')
   theta0 = get(gcf,'userdata');
else
   theta0 = swinginit(0.862,-0.994);
end
set(gcf,'userdata',theta0)

delete(findobj('type', 'uicontrol', 'style', 'pushbutton', 'string','close'))
if isempty(findobj('string','stop'))
   uicontrol('style','toggle','string','stop','value',0, ...
      'units','normalized','position',[.02 .02 .09 .05]);
end

if nargin < 3, orbitval = 0; end
if isempty(findobj('string','orbit'))
   uicontrol('style','toggle','string','orbit','value',orbitval, ...
      'units','normalized','position',[.14 .02 .09 .05], ...
      'callback','swinger(''orbit'')');
end

u0 = [theta0; 0; 0];
tspan = [0 1.e6];
opts = odeset('mass',@swingmass,'outputfcn',@swingplot,'maxstep',0.05);
ode23(@swingrhs,tspan,u0,opts);


% ------------------------

function M = swingmass(t,u)
% Mass matrix for classic double pendulum.
c = cos(u(1)-u(2));
M = [1 0 0 0; 0 1 0 0; 0 0 2 c; 0 0 c 1];


% ------------------------

function f = swingrhs(t,u)
% Driving force for classic double pendulum.
g = 1;
s = sin(u(1)-u(2));
f = [u(3); u(4); -2*g*sin(u(1))-s*u(4)^2; -g*sin(u(2))+s*u(3)^2];


% ------------------------

function theta = swinginit(x,y)
% Angles to starting point.
%   swinginit(0,-2) = [0 0]'
%   swinginit(sqrt(2),0) = [3*pi/4 pi/4]'
%   swinginit(0,2) = [pi pi]'

r = norm([x,y]);
if r > 2
   alpha = 0;
else
   alpha = acos(r/2);
end
beta = atan2(y,x) + pi/2;
theta = [beta+alpha; beta-alpha];


% ------------------------

function status = swingplot(t,u,task)
% Plot function for classic double pendulum.
switch task
   case 'init'
      theta = u(1:2);
      x = cumsum(sin(theta));
      y = cumsum(-cos(theta));
      orbit = get(findobj('string','orbit'),'value');
      if orbit
         h = plot([x(2) x(2)],[y(2) y(2)],'-','erasemode','none');
      else
         h = plot([0; x],[0; y],'o-');
      end
      set(h,'userdata',orbit);
      axis(2.25*[-1 1 -1 1])
      axis square
      ttl = title(sprintf('t = %8.1f',t));
      set(gca,'userdata',ttl)
      xlabel('Click to reinitialize');
   case ''
      h = get(gca,'child');
      theta = u(1:2);
      x = cumsum(sin(theta));
      y = cumsum(-cos(theta));
      orbit = get(h,'userdata');
      if orbit
         xo = get(h,'xdata');
         yo = get(h,'ydata');
         set(h,'xdata',[xo(2) x(2)],'ydata',[yo(2) y(2)])
      else
         set(h,'xdata',[0; x],'ydata',[0; y])
      end
      ttl = get(gca,'userdata');
      set(ttl,'string',sprintf('t = %8.1f',t))
      drawnow
      stop = findobj('string','stop');
      status = isempty(stop) || get(stop,'value');
   case 'done'
      set(findobj('string','stop'),'style','push', ...
         'string','close','callback','close(gcf)');
      delete(findobj('string','orbit'));
end
