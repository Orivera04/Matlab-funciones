function E = expm2(A)
%EXPM2	Matrix exponential via Taylor series.
%	E = expm2(A) illustrates the classic definition for the
%	matrix exponential.  As a practical numerical method,
%	this is often slow and inaccurate.
%	See also EXPM, EXPM1, EXPM3.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

% Taylor series for exp(A)
E = zeros(size(A));
F = eye(size(A));
k = 1;
while norm(E+F-E,1) > 0
   E = E + F;
   F = A*F/k;
   k = k+1;
end
