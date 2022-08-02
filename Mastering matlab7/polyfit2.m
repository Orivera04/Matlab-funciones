% polyfit2.m 
% find weighted polynomial coefficients

x = [0 .1 .2 .3 .4 .5 .6 .7 .8 .9 1]';
y = [-.447 1.978 3.28 6.16 7.08 7.34 7.66 9.56 9.48 9.30 11.2]';
n = 3;
pm = polyfit(x,y,n) % MATLAB polyfit result

% code from vander3.m
m = length(x);   % number of elements in x
V = ones(m,n+1); % preallocate memory for result
for i=n:-1:1     % build V column by column
   V(:,i) = x.*V(:,i+1);
end

w = ones(size(x)); % default weights of one
w(4) = 2;
w(7) = 10;

V = V.*repmat(w,1,n+1);
y = y.*w;

p = (V\y)'

% w=ones(size(x));
% w(4)=100;
% p2=lscov(V,y,w)
% 
% xi = linspace(0,1,100);
% yi = polyval(p,xi);
% yi2=polyval(p2,xi);
% plot(x,y,'-o',xi,yi,'--',xi,yi2)
% xlabel('x'), ylabel('y=f(x)')
% title('Figure 20.2:  Second Order Curve Fitting')
