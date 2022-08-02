
function [x, dist] = lsqne(A, b)

% The least-squares solution x to the overdetermined 
% linear system Ax = b. Matrix A must be of full column
% rank.

% Input:
%       A- matrix of the system
%       b- the right-hand sides
% Output:
%       x- the least-squares solution 
%       dist- Euclidean norm of the residual b - Ax

[m, n] = size(A);
if (m <= n)
   error('System is not overdetermined')
end
if (rank(A) < n)
   error('Matrix must be of full rank')
end
H = chol(A'*A);
x = H\(H'\(A'*b));
r = b - A*x;
dist = norm(r);
