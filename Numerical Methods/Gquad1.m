
function [s, w, x] = Gquad1(fun, a, b, n, type, varargin)

% Numerical integration using either the Gauss-Legendre (type = 'L')
% or the Gauss-Chebyshev (type = 'C') quadrature with n (n > 0) nodes. 
% fun is a string representing the name of the function that is 
% integrated from a to b. For the Gauss - Chebyshev quadrature
% it is assumed that a = -1 and b = 1.
% The output parameters s, w, and x hold the computed approximation
% of the integral, list of weights, and the list of nodes, 
% respectively.

d = zeros(1,n-1);
if type == 'L'
   k = 1:n-1;
   d = k./(2*k - 1).*sqrt((2*k - 1)./(2*k + 1));
   fc = 2;
   J = diag(d,-1) + diag(d,1); 
   [u,v] = eig(J);
   [x,j] = sort(diag(v));
   w = (fc*u(1,:).^2)';
   w = w(j)';
   w = 0.5*(b - a)*w;
   x = 0.5*((b - a)*x + a + b);
else
   x = cos((2*(1:n) - (2*n + 1))*pi/(2*n))';
   w(1:n) = pi/n;
end
f = feval(fun,x,varargin{:});
s = w*f(:);
w = w';

