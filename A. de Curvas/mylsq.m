
function x = mylsq(A, b, R)

% The least squares solution x to the overdetermined
% linear system Ax = b. Matrix R is such that R = Q'A,
% where Q is a matrix whose columns are orthonormal.

m = length(b);
[n,n] = size(R);
if m < n
   error('System is not overdetermined')
end
x = R\(R'\(A'*b));
r = b - A*x;
e = R\(R'\(A'*r));
x = x + e;

