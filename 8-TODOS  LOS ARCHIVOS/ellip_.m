% ellip_(x0, y0, rx, ry) draws an ellipse.
% x0, y0:  coordinates of center point
% rx, ry:  radii in x and y  directions
% Example>> ellip_(0, 0, 0.2, 0.5)
% Copyright S. Nakamura, 1995
function   ellip_(x0,y0,rx,ry)
delt = 2*pi/30;
t = 0:delt:2*pi;
x=rx*cos(t)+x0;  y = ry*sin(t)+y0;
plot(x,y)
