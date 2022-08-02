% mm2604.m
x = linspace(0,2*pi,30);
y = sin(x);
z = cos(x);
plot(x,y,'b:p',x,z,'c-',x,1.2*z,'m+')
title('Figure 26.4: Linestyles and Markers')
