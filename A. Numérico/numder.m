
function der = numder(fun, x, h, n, varargin)

% Approximation der of the first order derivative, at the point x, 
% of a function named by the string fun. Parameters h and n
% are user supplied values of the initial step size and the number
% of performed iterations in the Richardson extrapolation.
% For fuctions that depend on parameters their values must follow
% the parameter n.

d = [];
for i=1:n
   s = (feval(fun,x+h,varargin{:})-feval(fun,x-h,varargin{:}))/(2*h);
   d = [d;s];
   h = .5*h;
end
l = 4;
for j=2:n
   s = zeros(n-j+1,1);
   s = d(j:n) + diff(d(j-1:n))/(l - 1);
   d(j:n) = s;
   l = 4*l;
end
der = d(n);


