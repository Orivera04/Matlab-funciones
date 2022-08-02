
function [s, w, x] = cNCqf(fun, a, b, n, varargin)

% Numerical approximation s of the definite integral of
% f(x). fun is a string containing the name of the integrand f(x). 
% Integration is over the interval [a, b]. 
% Method used:
% n-point closed Newton-Cotes quadrature formula.
% The weights and the nodes of the quadrature formula
% are stored in vectors w and x, respectively.

if n < 2
   error(' Number of nodes must be greater than 1')
end
x = (0:n-1)/(n-1);
f = 1./(1:n);
V = Vander(x);
V = rot90(V);
w = V\f';
w = (b-a)*w;
x = a + (b-a)*x;
x = x';
s = feval(fun,x,varargin{:});
s = w'*s;




