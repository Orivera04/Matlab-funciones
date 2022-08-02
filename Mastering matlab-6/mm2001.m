x = 0:12;
y = tan(pi*x/25);
xi = linspace(0,12);
yi = spline(x,y,xi);
plot(x,y,'o',xi,yi)
title('Figure 20.1: Spline Fit')