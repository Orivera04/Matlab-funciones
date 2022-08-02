
function x = lsqsvd(A, b)

% The least squares solution x to the overdetermined
% linear system Ax = b using the reduced singular
% value decomposition of A.

[m, n] = size(A);
if m <= n
   error('System is not overdetermined')
end
[U,S,V] = svd(A,0);
d = diag(S);
tol = max(size(A))*d(1)*eps;
r = sum(d > tol);
b1 = U(:,1:r)'*b;
w = d(1:r).\b1;
x = V(:,1:r)*w;
re = b - A*x;     % One step of iterative refinement
b1 = U(:,1:r)'*re;
w = d(1:r).\b1;
e = V(:,1:r)*w;
x = x + e;

