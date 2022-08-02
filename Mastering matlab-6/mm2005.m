t = linspace(0,3*pi,15);
x = sqrt(t).*cos(t);
y = sqrt(t).*sin(t);

plot(x,y)
xlabel('X')
ylabel('Y')
title('Figure 20.5: Spiral Y=f(X)')