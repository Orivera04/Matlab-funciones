x = [0 .1 .2 .3 .4 .5 .6 .7 .8 .9 1];
y = [-.447 1.978 3.28 6.16 7.08 7.34 7.66 9.56 9.48 9.30 11.2]; % data
n = 2; % order of fit
p = polyfit(x,y,n); % find polynomial coefficients
dp=polyder(p);
dyp=polyval(dp,x);
dy = diff(y)./diff(x); % compute differences and use array division
xd = x(1:end-1);% create new x axis array since dy is shorter than y
plot(xd,dy,x,dyp,':')
ylabel('dy/dx'), xlabel('x')
title('Figure 23.5: Forward Difference Derivative Approximation')
