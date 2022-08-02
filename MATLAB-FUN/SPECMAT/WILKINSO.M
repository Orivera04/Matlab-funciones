function W = Wilkinson(n)
%WILKINSON Wilkinson's eigenvalue test matrix.
%	WILKINSON(n) is J. H. Wilkinson's eigenvalue test matrix, Wn+.
%	It is a symmetric, tridiagonal matrix with pairs of nearly,
%	but not exactly, equal eigenvalues.  
%	The most frequently used case is WILKINSON(21).
%	For example, WILKINSON(7) is
%
%	       3  1  0  0  0  0  0
%	       1  2  1  0  0  0  0
%	       0  1  1  1  0  0  0
%	       0  0  1  0  1  0  0
%	       0  0  0  1  1  1  0
%	       0  0  0  0  1  2  1
%	       0  0  0  0  0  1  3

%	Copyright (c) 1984-94 by The MathWorks, Inc.

m = (n-1)/2;
e = ones(n-1,1);
W = diag(abs(-m:m)) + diag(e,1) + diag(e,-1);
