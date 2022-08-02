function fixedpoint(f,xmin,xmax,xstart);
% FIXEDPOINT  Illustrate fixed point iteration.
% fixedpoint(f,xmin,xmax,xstart) tries to solve x = f(x).
% Examples
%   f = @(x) sqrt(1+x); fixedpoint(f, -1, 4, 0)  (Default)
%   f = @(x) 1./x+1; fixedpoint(f, .5, 2.5, 1)
%   f = @(x) cos(x); fixedpoint(f, -pi/4, pi/2, 0)
%   a = sqrt(2); f = @(x) a.^x; fixedpoint(f, 1, 5, 3)
%   a = 3+randn, f = @(x) a*x.*(1-x); ...
%      fixedpoint(f, 0, 1, .5), title([num2str(a) '*x*(1-x)'])  

% Default example

if nargin == 0
   f = @(x) sqrt(1 + x);
   xmin = -1;
   xmax = 4;
   xstart = 0;
end

% Iteration

x = xstart;
y = f(x);
n = 1;
while (x(n) ~= y(n)) & (n < 50) & (max(abs(y)) < 100)
   n = n+1;
   x(n) = y(n-1);
   y(n) = f(x(n));
end

% Plot

t = sort([xmin:(xmax-xmin)/256:xmax x]);
x = [x; x];
y = [x(1) y(1:n-1); y];
plot(t,t,'-',t,f(t),'-',x(:),y(:),'k-',x(end),y(end),'ro');
axis tight square
set(zoom(gcf),'ActionPostCallback','zoomer')
