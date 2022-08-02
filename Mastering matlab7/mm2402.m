% mm2402.m
x = linspace(-1,2,100);
y = humps(x);
z = cumtrapz(x,y);
size(z)
plotyy(x,y,x,z)
grid on
xlabel('x')
ylabel('humps(x) and integral of humps(x)')
title('Figure 24.2: Cumulative Integral of humps(x)')