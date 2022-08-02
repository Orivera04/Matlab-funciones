
function y = rfun(x, a, b, c)

% A simple rational function.

y = (a+b.*x)./(1+c.*x.^2);
y = y(:);