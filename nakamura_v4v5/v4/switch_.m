% switch_(u, w, p1,p2) draws a switch symbol.
% u: switch size 
% w: relative height of switch 
% p1: coordinate pair for starting point
% p2: same for ending point
% Example>> 
%       p1 =[1,0]; p2=[2,0]; switch_(0.4, 1.2, p1,p2)
% Copyright S. Nakamura, 1995
function y =  switch_(u, w, p1,p2)
c = (p2(1)-p1(1))/2;  d = (p2(2)-p1(2))/2;
f = (p2(1)+p1(1))/2;  g = (p2(2)+p1(2))/2;
x1 =[-1,-0.5*u, 0.5*u];
y1 = w*[0, 0, 0.5*u];
x2 = [0.5*u, 1];
y2 = [0,0];
 x1 = c*x1 - d*y1 + f;
 y1 = d*x1 + c*y1 + g;
 x2 = c*x2 - d*y2 + f;
 y2 = d*x2 + c*y2 + g;
plot( x1, y1)
plot( x2, y2)


