% mm2105.m

t = linspace(0,3*pi,15);
x = sqrt(t).*cos(t);
y = sqrt(t).*sin(t);

plot(x,y)
xlabel('X')
ylabel('Y')
title('Figure 21.5: Spiral Y=f(X)')