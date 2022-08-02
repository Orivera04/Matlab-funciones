x = linspace(-1,3);
p = [1 4 -7 -10];
v = polyval(p,x);
plot(x,v)
title('Figure 19.1: x{^3} + 4x{^2} - 7x -10')
xlabel('x')