% mm2610.m
close
x = linspace(0,2*pi,30);
y = sin(x);
z = cos(x);
plot(x,y,x,z)
legend('sin(x)','cos(x)')
title('Figure 26.10: Legend Example')
