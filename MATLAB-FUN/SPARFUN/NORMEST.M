function [e,cnt] = normest(S,tol)
%NORMEST Estimate the 2-norm.
%	NORMEST(S) is an estimate of the 2-norm of the matrix S.
%	NORMEST(S,tol) uses relative error tol instead of 1.e-6.
%	[nrm,cnt] = NORMEST(S) also gives the number of power iterations used.

%	C. Moler, 4-30-91/92.
%	Copyright (c) 1984-94 by The MathWorks, Inc.

if nargin < 2, tol = 1.e-6; end
x = sum(abs(S))';
e = norm(x);
x = x/e;
cnt = 0;
e0 = 0;
while abs(e-e0) > tol*e
   e0 = e;
   Sx = S*x;
   e = norm(Sx);
   x = S'*Sx;
   x = x/norm(x);
   cnt = cnt+1;
end
