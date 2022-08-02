
function [rn, r1] = Romberg(fun, a, b, n, varargin)

% Numerical approximation rn of the definite integral from a to b 
% that is obtained with the aid of Romberg's method with n rows 
% and n columns. fun is a string that names the integrand. 
% If integrand depends on parameters, say p1, p2, ... , then
% they should follow the parameter n.
% Second output parameter r1 holds approximate values of the
% computed integral obtained with the aid of the composite
% trapezoidal rule using 1, 2, ... , n subintervals.

h = b - a;
d = 1;
r = zeros(n,1);
r(1) = .5*h*sum(feval(fun,[a b],varargin{:}));
for i=2:n
   h = .5*h;
   d = 2*d;
   t = a + h*(1:2:d);
   s = feval(fun, t, varargin{:});
   r(i) = .5*r(i-1) + h*sum(s);
end
r1 = r;
d = 4;
for j=2:n
   s = zeros(n-j+1,1);
   s = r(j:n) + diff(r(j-1:n))/(d - 1);
   r(j:n) = s;
   d = 4*d;
end
rn = r(n);

   


