% mm2406.m

x = linspace(0,2*pi);
y = sin(x);
dy = diff(y)/(x(2)-x(1)); 
xd = x(2:end);
plot(x,y,xd,dy)
axis tight
xlabel('x'), ylabel('sin(x) and cos(x)')
title('Figure 24.6: Backward Difference Derivative Approximation')