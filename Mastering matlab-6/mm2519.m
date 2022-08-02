t = linspace(0,2*pi);
r = sin(2*t).*cos(2*t);
subplot(2,2,1)
polar(t,r), title('Figure 25.19a: Polar Plot')
z = eig(randn(20));
subplot(2,2,2)
compass(z)
title('Figure 25.19b: Compass Plot')
subplot(2,2,3)
feather(z)
title('Figure 25.19c: Feather Plot')
subplot(2,2,4)
v = randn(1000,1)*pi;
rose(v)
title('Figure 25.19d: Angle Histogram')