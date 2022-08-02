% mm2603.m
x = linspace(0,2*pi,30);
y = sin(x);
z = cos(x);
W=[y;z];
plot(W,x) % plot x vs. the columns of W
title('Figure 26.3: Change Argument Order')