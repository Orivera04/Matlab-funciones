% capacit_(u,w, p1,p2) plots a capacitor symbol.
% u: capacitor gap width 
% w: width 
% p1: coordinate pair for starting point
% p2: same for ending point
% Example>> p1 =[1,0]; p2=[2,0]; capacit_(0.2, 0.4, p1,p2)
% Copyright S. Nakamura, 1995 
function y =  capacit_(u,w, p1,p2)
c = (p2(1)-p1(1))/2;  d = (p2(2)-p1(2))/2;
f = (p2(1)+p1(1))/2;  g = (p2(2)+p1(2))/2; 
x1 =[-1,-u];  y1 = [0, 0];
x2 = [-u,-u]; y2 = [-1,1]*w;
x3 = [u,u];   y3 = [-1,1]*w;
x4 =[u,1];    y4 = [0, 0];
 xx1 = c*x1 - d*y1 + f;   yy1 = d*x1 + c*y1 + g;
 xx2 = c*x2 - d*y2 + f;   yy2 = d*x2 + c*y2 + g;
 xx3 = c*x3 - d*y3 + f;   yy3 = d*x3 + c*y3 + g;
 xx4 = c*x4 - d*y4 + f;   yy4 = d*x4 + c*y4 + g;
plot(xx1,yy1)
plot(xx2,yy2)
plot(xx3,yy3)
plot(xx4,yy4)