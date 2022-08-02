%cfield(x,y,z,mx,Mx,my,My,c1,c2,S)
%
%   Draws a "circle-field" at the points  (x(i),y(i)) 
%     specified by the vectors  x  and  y.
%   At each point, an  "x"  of color  c1  and a circle of 
%     color  c2  and size proportional to z(i) is drawn.
%   If  c1  is specified,  c2  must also be specified.
%     Default colors are cyan and yellow.
%
%   mx, Mx, my, My  
%     are optional arguments specifying the range to be used for 
%     the axes (defaults used are  min(x), max(x), min(y), max(y)
%     +/- a tenth of the range).
%
%   S is an optional number that scales the length of the arrows.
%     Default is 1.

% kwong@mcs.anl.gov  11/14/93


function cfield(x,y,z,mx,Mx,my,My,c1,c2,S)

% PARSE THE ARGUMENT LIST

if nargin <= 4 | nargin == 7 | nargin == 8, c1 = 'c'; c2 = 'y'; end
if nargin == 4, S = mx(1);
elseif nargin == 5, c1 = mx; c2 = Mx;
elseif nargin == 6, c1 = mx; c2 = Mx; S = my;
end

if ~exist('S'), S = 1; end
if nargin < 7
  mx = min(min(x)); Mx = max(max(x)); Dx = (Mx-mx)/10;
  mx = mx-Dx;  Mx = Mx+Dx;
  my = min(min(y)); My = max(max(y)); Dy = (My-my)/10;
  my = my-Dy;  My = My+Dy;
end

s = S*min(Mx-mx,My-my)/12;                      % DEFINE THE 
t = 0:0.1:2*pi; cx = s*cos(t); cy = s*sin(t);   % UNIT CIRCLE

x = x(:); y = y(:); z = z(:)/max(max(z));  % CHANGE TO VECTORS
plot(x,y,[ c1 'x' ]);                      % PLOT x POINTS
hold on
for i = 1:length(x)                        % PLOT CIRCLES
  plot(x(i)+z(i)*cx,y(i)+z(i)*cy,c2);
end
axis([mx Mx my My]), hold off              % TURN OFF HOLD
