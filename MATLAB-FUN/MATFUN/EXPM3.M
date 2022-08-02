function E = expm3(A)
%EXPM3	Matrix exponential via eigenvalues and eigenvectors.
%	E = expm3(A) illustrates one possible way to compute the matrix
%	exponential.  As a practical numerical method, the accuracy
%	is determined by the condition of the eigenvector matrix.
%	See also EXPM, EXPM1, EXPM2.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

[V,D] = eig(A);
E = V * diag(exp(diag(D))) / V;
