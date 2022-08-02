function dummy = pltarrow(x,y,l,lcolor,ltype)
% dummy = pltarrow(x,y,l,ltype)
% Function 'pltarrow' draws a line with an arrow head. The size is controlled by l.
% If x and y have more than two data points, the arrow direction is determined based
% on the last two data points.
%
% Input
%    x,y    : data points
%    l      : arrow head size
%    lcolor : line color (r,g,b,w,y)
%    ltype  : line type (-, --, -., .)
%
% Example : pltarrow([1 2.3],[3 -2.7],.05,'y','-')
%           draws a yellow solid line from (1,3) to (2.3,-2.7) with 
%           an arrow head whose size is .2.
%

% Note : To prevent the distortion due to aspect ratio, the function draws 
%        a one sided arrow head.

% Keeyoung Choi, 2/8/1997

ltype1 = [lcolor ltype];
ltype2 = [lcolor '-'];

n = length(x);
if (n<2),
  error('Not enough data to plot - x and y should have at least two elements.')
end

theta = 15*pi/180;
dx = x(n)-x(n-1);
dy = y(n)-y(n-1);
direction = [dx dy]'; direction = direction/norm(direction);

ct = cos(theta); st = sin(theta);
p3 = [x(n); y(n)] - l*[ct -st; st ct]*direction;

plot(x,y,ltype1,[x(n) p3(1)],[y(n) p3(2)],ltype2)

dummy = 0;


