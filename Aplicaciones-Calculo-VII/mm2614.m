% mm2614.m
x = -2*pi:pi/10:2*pi;
y = sin(x);
z = 3*cos(x);
subplot(2,1,1), plot(x,y,x,z)
title('Figure 26.14a: Two plots on the same scale.');
subplot(2,1,2), plotyy(x,y,x,z)
title('Figure 26.14b: Two plots on different scales.');
