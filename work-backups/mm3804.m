% polyfit3.m 
% find weighted polynomial coefficients using lscov

x = [0 .1 .2 .3 .4 .5 .6 .7 .8 .9 1]';
y = [-.447 1.978 3.28 6.16 7.08 7.34 7.66 9.56 9.48 9.30 11.2]';
n = 3;
pm = polyfit(x,y,n); % MATLAB polyfit result

% create Vandermonde matrix using code from vander3.m

m = length(x);   % number of elements in x
V = ones(m,n+1); % preallocate memory for result

for i=n:-1:1     % build V column by column
   V(:,i) = x.*V(:,i+1);
end

w = ones(size(x)); % default weights of one
w(4) = 2^2;
w(7) = 10^2;

p = lscov(V,y,w)';

xi = linspace(0,1,100);
ym = polyval(pm,xi);
yw = polyval(p,xi);

pt = false(size(x));
pt([4 7]) = true;

plot(x(~pt),y(~pt),'x',x(pt),y(pt),'o',xi,ym,'--',xi,yw)

xlabel('x'), ylabel('y=f(x)')
title('Figure 38.4:  Weighted Curve Fitting')
