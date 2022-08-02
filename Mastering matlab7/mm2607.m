% mm2607.m
x = linspace(0,2*pi,30);
y = sin(x);
plot(x,y)
title('Figure 26.7: Fixed Axis Scaling')
axis([0 2*pi -1.5 2])  % change axis limits