function a = vander(c)
%VANDER	Vandermonde matrix.
%	VANDER(C) returns the Vandermonde matrix whose second to
%	last column is C.  The j-th column of a Vandermonde
%	matrix is given by A(:,j) = C^(n-j).

%	J.N. Little 1-28-88
%	Copyright (c) 1984-94 by The MathWorks, Inc.

n = max(size(c));
c = c(:);
a = ones(n);
for j = 1:n
    a(:,j) = c.^(n-j);
end
