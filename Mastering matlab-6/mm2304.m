x = [0 .1 .2 .3 .4 .5 .6 .7 .8 .9 1];
y = [-.447 1.978 3.28 6.16 7.08 7.34 7.66 9.56 9.48 9.30 11.2]; % data
n = 2; % order of fit
p = polyfit(x,y,n) % find polynomial coefficients
xi = linspace(0,1,100);
yi = polyval(p,xi); % evaluate polynomial
plot(x,y,'-o',xi,yi,'--')
xlabel('x'), ylabel('y=f(x)')
title('Figure 23.4: Second Order Curve Fitting')