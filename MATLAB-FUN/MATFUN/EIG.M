%EIG 	Eigenvalues and eigenvectors.
% 	EIG(X) is a vector containing the eigenvalues of a square
% 	matrix X.
%
%	[V,D] = EIG(X) produces a diagonal matrix D of
% 	eigenvalues and a full matrix V whose columns are the
% 	corresponding eigenvectors so that X*V = V*D.
% 
% 	[V,D] = EIG(X,'nobalance') performs the computation with
% 	balancing disabled, which sometimes gives more accurate results
%	for certain problems with unusual scaling.
% 
% 	Generalized eigenvalues and eigenvectors.
%
% 	EIG(A,B) is a vector containing the generalized eigenvalues
% 	of square matrices A and B. 
%
% 	[V,D] = EIG(A,B) produces a diagonal matrix D of general-
% 	ized eigenvalues and a full matrix V whose columns are the
% 	corresponding eigenvectors so that A*V = B*V*D.

%	Copyright (c) 1984-94 by The MathWorks, Inc.
%	Built-in function.
