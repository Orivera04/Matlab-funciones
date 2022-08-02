% mm2102.m
x=[0 2 4 5 7.5 10];
y=exp(-x/6).*cos(x);

cs=spline(x,y);
ch=pchip(x,y);

xi=linspace(0,10);

ysi=ppval(cs,xi);
yhi=ppval(ch,xi);

plot(x,y,'o',xi,ysi,':',xi,yhi)
legend('data','spline','hermite')
title('Figure 21.2: Spline and Hermite Interpolation')