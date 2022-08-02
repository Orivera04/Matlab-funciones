function poles(x,y,z,width)

%POLES  3d bar plot.
%       POLES(X,Y,Z,WIDTH) Plots (possibly irregular)
%       three-dimensional data by plotting a pole of height Z at
%       location (X,Y). X, Y and Z should be vectors or matrices
%       of the same size.  The optional argument WIDTH = [xw,yw]
%       gives the x and y dimensions of the pole (defaults to
%       WIDTH = [xrange/15 yrange/15]).
%
%       Example 1: 
%          x = randn(1,20);y = randn(1,20);
%          z = exp(-sqrt(x.^2 + y.^2)); 
%          poles(x,y,z)
%
%       Example 2 (How not to present your results):
%          poles(1:10,zeros(1,10),rand(1,10),[.7 1]);
%          view(-1,2),title('Revenue')
%
%       Example 3:
%          [x,y,z] = peaks(15);
%          poles(x,y,z,[.2 .2])
%
%        Example 4 (Escher gone wrong):
%           x = [1:9 10*ones(1,10) 9:-1:2 ones(1,10)];
%           y = [ones(1,10) 2:9 10*ones(1,10) 9:-1:1];
%           z=10 + (1:37);
%           poles(x,y,z,[1 1])
%           view(-30,60)

% A. Knight, 1992
% andrew.knight@defence.dsto.gov.au

switch nargin
case 1
  [n,m] = size(x);
  z = x;
  [x,y] = meshgrid(1:m,1:n);
   maxx = max(max(x));
   minx = min(min(x));
   maxy = max(max(y));
   miny = min(min(y));
   xw = (maxx - minx)/15;
   yw = (maxy - miny)/15;
case 2
   [n,m] = size(x);
   z = x;
   width = y;
   [x,y] = meshgrid(1:m,1:n);
   xw = width(1);
   yw = width(2);
case 3
   xw = (max(x) - min(x))/15;
   yw = (max(y) - min(y))/15;
case 4
   xw = width(1);
   yw = width(2);
otherwise
   error('Wrong number of arguments')
end

x = x(:);
y = y(:);
z = z(:);

xc = xw*([1 1;1 1;0 0;0 0;1 1;NaN NaN;1 1;0 0] - 0.5);
yc = yw*([0 0;1 1;1 1;0 0;0 0;NaN NaN;0 1;0 1] - 0.5);
zc =     [1 0;1 0;1 0;1 0;1 0;NaN NaN;1 1;1 1];

HoldWasOn = ishold;
for i = 1:length(x)
   xp = xc + x(i);
   yp = yc + y(i);
   zp = zc*z(i);
   surf(xp,yp,zp)
   if i==1
     hold on
   end
end
grid

if ~HoldWasOn
  hold off
end
