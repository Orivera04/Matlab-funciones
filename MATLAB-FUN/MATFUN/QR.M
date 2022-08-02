%QR  	Orthogonal-triangular decomposition.
% 	[Q,R] = QR(X) produces an upper triangular matrix R of the same
%	dimension as X and a unitary matrix Q so that X = Q*R.
% 	[Q,R,E] = QR(X) produces a permutation matrix E , an upper
%	triangular R and a unitary Q so that X*E = Q*R.  The column
%	permutation E is chosen so that abs(diag(R)) is decreasing.
%	[Q,R]  = QR(X,0) produces the "economy size" decomposition.  If X
%	is m-by-n with m > n, then only the first n columns of Q are computed.
%	[Q,R,E] = QR(X,0) produces an "economy size" decompostions in which E
%	is a permutation vector, so that Q*R = X(:,E).  The column
%	permutation E is chosen so that abs(diag(R)) is decreasing.
%	By itself, QR(X) returns the output of LINPACK'S ZQRDC routine.
%	TRIU(QR(X)) is R.
%
%	See also QRDELETE, QRINSERT.

%	Copyright (c) 1984-94 by The MathWorks, Inc.
%	Built-in function.
