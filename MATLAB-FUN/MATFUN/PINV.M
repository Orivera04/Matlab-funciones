function X = pinv(A,tol)
%PINV	Pseudoinverse.
%	X = PINV(A) produces a matrix X of the same dimensions
%	as A' so that A*X*A = A, X*A*X = X and AX and XA
%	are Hermitian. The computation is based on SVD(A) and any
%	singular values less than a tolerance are treated as zero.
%	The default tolerance is MAX(SIZE(A)) * NORM(A) * EPS.
%	This tolerance may be overridden with X = PINV(A,tol).
%
%	See also RANK.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

[U,S,V] = svd(A,0);
if min(size(S)) == 1
   S = S(1);
else
   S = diag(S);
end
if (nargin == 1)
   tol = max(size(A)) * S(1) * eps;
end
r = sum(S > tol);
if (r == 0)
   X = zeros(size(A'));
else
   S = diag(ones(r,1)./S(1:r));
   X = V(:,1:r)*S*U(:,1:r)';
end
