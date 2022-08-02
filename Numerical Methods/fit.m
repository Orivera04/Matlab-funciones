
function c = fit(n, t, y)

% Function fit calculates coefficients c of the 
% least-squares approximating polynomial of
% degree n (n>=0). The coordinates of points
% to be fitted are stored in the vectors t and y,
% respectively. Graphs of the data points and the
% least-squares approximating polynomial are also
% generated.

if n >= length(t)
   error('Degree is too big')
end
t = t(:);
y = y(:);
v = fliplr(vander(t));
v = v(:,1:(n+1));
c = v\y;
c = fliplr(c');
x = linspace(min(t),max(t));
w = polyval(c, x);
c = c(:);
h1_line = plot(t,y,'ro',x,w);
set(h1_line(1),'LineWidth',1.4)
title(sprintf('Fitting polynomial of degree at most %2.0f',n))
legend('data points','fitting polynomial')
