% P7_9.M Compare 6th order polynomial and spline fit
%
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
subplot(2,1,1),plot(x,y,'o',xplot,f,'-')
title('Polynomial fit 6th order')
axis([-4 4 -1 3.5])
grid 
%
yspline=spline(x,y,xplot);
subplot(2,1,2),plot(x,y,'o',xplot,yspline,'-')
title('Spline fit ')
axis([-4 4 -1 3.5])
grid 
%
% Add a few comments to introduce the script and
%  explain it