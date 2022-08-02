function co = ctrb(a,b)
%CTRB	Form controllability matrix.
%	CTRB(A,B) returns the controllability matrix
%	Co = [B AB A^2B ...]

%	Copyright (c) 1986-93 by the MathWorks, Inc.

[m,n] = size(a);
co = b;
for i=1:n-1
	co = [b a*co];
end

