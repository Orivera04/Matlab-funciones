% function box_(hi,p1,p2) draws a box.
% hi=height of box; p1 and p2 are coordinates of center point
% of the left side of box wall, and p2 the same for the right.
% Example >> p1 = [0,0]; p2 =[1,0]; box_(0.5,p1,p2)
% Copyright S. Nakamura, 1995
function dummy =  box_(hi, p1,p2)
c = (p2(1)-p1(1))/2;  d = (p2(2)-p1(2))/2;
f = (p2(1)+p1(1))/2;  g = (p2(2)+p1(2))/2;
x = [-1 1 1 -1 -1]; y = hi*[-1 -1 1 1 -1];
 xx1 = c*x - d*y + f;   yy1 = d*x + c*y + g;
plot(xx1,yy1)



