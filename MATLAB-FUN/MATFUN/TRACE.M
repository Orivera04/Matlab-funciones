function t = trace(a)
%TRACE	Sum of diagonal elements.
%	TRACE(A) is the sum of the diagnonal elements of A, which is
%	also the sum of the eigenvalues of A.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

t = sum(diag(a));
