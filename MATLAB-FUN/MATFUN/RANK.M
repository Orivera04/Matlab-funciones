function r = rank(x,tol)
%RANK	Number of linearly independent rows or columns.
%	K = RANK(X) is the number of singular values of X
%	that are larger than MAX(SIZE(X)) * NORM(X) * EPS.
%	K = RANK(X,tol) is the number of singular values of X that
%	are larger than tol.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

s = svd(x);
if (nargin == 1)
    tol = max(size(x)) * max(s) * eps;
end
r = sum(s > tol);
