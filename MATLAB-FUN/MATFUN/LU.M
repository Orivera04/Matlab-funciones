%LU  	Factors from Gaussian elimination.
%	[L,U] = LU(X) stores a upper triangular matrix in U and a
%	"psychologically lower triangular matrix", i.e. a product
%	of lower triangular and permutation matrices, in L , so
%	that X = L*U.
%
% 	[L,U,P] = LU(X) returns lower triangular matrix L, upper
% 	triangular matrix U, and permutation matrix P so that
% 	P*X = L*U.
%
%	By itself, LU(X) returns the output from LINPACK'S ZGEFA routine.

%	Copyright (c) 1984-94 by The MathWorks, Inc.
%	Built-in function.
