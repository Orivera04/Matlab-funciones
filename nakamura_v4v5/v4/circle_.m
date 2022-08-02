% circle_(x0,y0,r) plots a circle of radius r at (x0,y0) 
% Example>>   circle_(0, 0, 0.77)
% Copyright S. Nakamura, 1995 
function dummy =  circle_(x0,y0,r)
delt = 2*pi/30;
t = 0:delt:2*pi;
x=r*cos(t)+x0;  y = r*sin(t)+y0;
plot(x,y)
