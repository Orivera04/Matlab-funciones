
function [s, w, x] = Gquad2(fun, n, type, varargin)

% Numerical integration using either the Gauss-Laguerre
% (type = 'L') or the Gauss-Hermite (type = 'H') with n (n > 0) nodes. 
% fun is a string containing the name of the function that is 
% integrated.
% The output parameters s, w, and x hold the computed approximation
% of the integral, list of weights, and the list of nodes, 
% respectively. 

if type == 'L'
   d = -(1:n-1);
   f = 1:2:2*n-1;
   fc = 1;
else
   d = sqrt(.5*(1:n-1));
   f = zeros(1,n);
   fc = sqrt(pi);
end
J = diag(d,-1) + diag (f) + diag(d,1);
[u,v] = eig(J);
[x,j] = sort(diag(v));
w = (fc*u(1,:).^2)';
w = w(j);
f = feval(fun,x,varargin{:});
s = w'*f(:);

