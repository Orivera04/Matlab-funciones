x = -2*pi:pi/10:2*pi;
y = sin(x);
z = 3*cos(x);
subplot(2,1,1), plot(x,y,x,z)
title('Figure 25.14a: Two plots on the same scale.');
subplot(2,1,2), plotyy(x,y,x,z)
title('Figure 25.14b: Two plots on different scales.');
