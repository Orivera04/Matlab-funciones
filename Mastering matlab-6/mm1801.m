%(MM1801.m plot)
x1 = linspace(0,2*pi,60);
x2 = linspace(0,2*pi,6);
plot(x1,sin(x1),x2,sin(x2),'--')
xlabel('x'),ylabel('sin(x)')
title('Figure 18.1: Linear Interpolation')
