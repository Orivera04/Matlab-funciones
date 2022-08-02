%EXPM	Matrix exponential.
%	EXPM(X) is the matrix exponential of X.  EXPM is computed using
% 	a scaling and squaring algorithm with a Pade approximation.
%	Although it is not computed this way, if X has a full set
%	of eigenvectors V with corresponding eigenvalues D, then
% 	[V,D] = EIG(X) and EXPM(X) = V*diag(exp(diag(D)))/V.
%	See EXPM1, EXPM2 and EXPM3 for alternative methods.
%
%	EXP(X) (that's without the M) does it element-by-element.

%	Copyright (c) 1984-94 by The MathWorks, Inc.
%	Built-in function.
