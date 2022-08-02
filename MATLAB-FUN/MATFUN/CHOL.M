%CHOL	Cholesky factorization.
%	CHOL(X) uses only the diagonal and upper triangle of X.
%	The lower triangular is assumed to be the (complex conjugate)
%	transpose of the upper.  If X is positive definite, then
%	R = CHOL(X) produces an upper triangular R so that R'*R = X.
%	If X is not positive definite, an error message is printed.
%
%	With two output arguments, [R,p] = CHOL(X) never produces an
%	error message.  If X is positive definite, then p is 0 and R
%	is the same as above.   But if X is not positive definite, then
%	p is a positive integer and R is an upper triangular matrix of
%	order q = p-1 so that R'*R = X(1:q,1:q).

%	Copyright (c) 1984-94 by The MathWorks, Inc.
%	Built-in function.
