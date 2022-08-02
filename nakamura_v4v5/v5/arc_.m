% Used in human_c.m
% Copyright S. Nakamura, 1995
function arc_(x0,y0, r, deg1,deg2)
x1=r*cos(deg1*180/pi);
x2=r*cos(deg2*180/pi);
dth=(deg2-deg1)/20;
th=deg1:dth:deg2;
th=th*pi/180;  
x=r*cos(th)+x0;
y=r*sin(th)+y0;
plot(x,y,':')
