%SVD 	Singular value decomposition.
%	[U,S,V] = SVD(X) produces a diagonal matrix S, of the same 
%	dimension as X and with nonnegative diagonal elements in
%	decreasing order, and unitary matrices U and V so that
%	X = U*S*V'.
%
% 	By itself, SVD(X) returns a vector containing diag(S).
%
% 	[U,S,V] = SVD(X,0) produces the "economy size"
% 	decomposition. If X is m-by-n with m > n, then only the
% 	first n columns of U are computed and S is n-by-n.

%	Copyright (c) 1984-94 by The MathWorks, Inc.
%	Built-in function.
