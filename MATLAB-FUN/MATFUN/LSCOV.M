function x = lscov(A,b,V)
%LSCOV	Least squares solution in the presence of known covariance.
%	X = LSCOV(A,b,V) returns the vector X that minimizes
%	(A*X-b)'*inv(V)*(A*X-b) for the case in which length(b) > length(X).
%	This is the over-determined least squares problem with covariance V.
%	The solution is found without needing to invert V which is a square
%	symmetric matrix with dimensions equal to length(b).
%
%	The classical linear algebra solution to this problem is:
%
%	    x = inv(A'*inv(V)*A)*A'*inv(V)*b
%
%	See also SLASH, NNLS, QR.

%	Reference:
%	    G. Strang, "Introduction to Applied Mathematics",
%	    Wellesley-Cambridge, p. 398, 1986.
%	L. Shure 3-31-89
%	Copyright (c) 1984-94 by The MathWorks, Inc.

[m,n] = size(A);
if m <= n
    error('Problem must be over-determined.');
end
[q,r] = qr(A);
efg = q'*V*q;
e = efg(1:n,1:n);
g = efg(n+1:m,n+1:m);
cd = q'*b;
f = efg(1:n,n+1:m);
c = cd(1:n);
d = cd(n+1:m);
r = r(1:n,1:n);
x = r\(c-f*(g\d));
