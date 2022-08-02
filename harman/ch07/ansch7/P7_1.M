% P7_1.M Fit a 6th order polynomial to data and plot results
%
x=-3:3;
y=[0.6 0.2 0.6 3.0 0.6 0.2 0.6];
%
fprintf(' Coefficients of 6th order polynomial')
p=polyfit(x,y,6)
xplot=[-4:0.01:4];
f=polyval(p,xplot);
%
clf
plot(x,y,'o',xplot,f,'-')
title('Polynomial fit 6th order')
axis([-4 4 -1 3.5])
grid 