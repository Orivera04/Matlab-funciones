% function damper_ plots(w,p0,p1) a damper symbol.
% w: width
% p1: coordinate pair for srating point
% p2: same for ending point
% Example>> p6=[1,1]; p7=[1,2]; damper_( 0.1, p6, p7) 
% Copyright S. Nakamura, 1995
function   damper_(w,p0,p1); 
%
c = (p1(1)-p0(1))/2;  d = (p1(2)-p0(2))/2;
f = (p1(1)+p0(1))/2;  g = (p1(2)+p0(2))/2;
s = 0.25;
x1 =[-1,-s];  y1 = [0, 0];
x2 = [-s,-s]; y2 = [-1.2,1.2]*w;
x3 = [s,s];   y3 = [-0.7,0.7]*w;
x4 =[s,1];    y4 = [0, 0];
 tx1 = c*x1 - d*y1 + f;   ty1 = d*x1 + c*y1 + g;
 tx2 = c*x2 - d*y2 + f;   ty2 = d*x2 + c*y2 + g;
 tx3 = c*x3 - d*y3 + f;   ty3 = d*x3 + c*y3 + g;
 tx4 = c*x4 - d*y4 + f;   ty4 = d*x4 + c*y4 + g;
plot( tx1, ty1)
plot( tx2, ty2)
plot( tx3, ty3)
plot( tx4, ty4)
x=[-s, 2*s]; y = [1.2,1.2]*w;
 tx = c*x - d*y + f;   ty = d*x + c*y + g;
plot( tx, ty)
x=[-s, 2*s]; y = [-1.2,-1.2]*w;
 tx = c*x - d*y + f;   ty = d*x + c*y + g;
plot( tx, ty)

