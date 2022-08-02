x=linspace(0,10);
y=sin(x);
z=2*cos(2*x);

xo = mminvinterp(x,y-z,0)
yo = interp1(x,y,xo)
[xo yo]

plot(x,y,x,z,xo,yo,'o')
xlabel X
ylabel Y
title 'Figure 38.3: Intersection Points'