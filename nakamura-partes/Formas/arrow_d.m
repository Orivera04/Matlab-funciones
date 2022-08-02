% function arrow_d draws an arrow sign by dots.
%   w width of arrow
%   p1 and p2:  starting and ending coordinate pairs
% Example >>   arrow_dot(0.2, [0.5,-0.5], [1, -0.5])
% Copyright S. Nakamura, 1995
function dummy =  arrow_dot(w, p1,p2)
c = (p2(1)-p1(1))/2;  d = (p2(2)-p1(2))/2;
f = (p2(1)+p1(1))/2;  g = (p2(2)+p1(2))/2;
x = [-1 1]; y = [0,0];
xx1 = c*x - d*y + f;   yy1 = d*x + c*y + g;
plot(xx1,yy1, ':')
x = [0.5, 1]; y = w*[0.5,0];
xx1 = c*x - d*y + f;   yy1 = d*x + c*y + g;
plot(xx1,yy1, ':')
x = [0.5, 1]; y = w*[-0.5,0];
xx1 = c*x - d*y + f;   yy1 = d*x + c*y + g;
plot(xx1,yy1, ':')



