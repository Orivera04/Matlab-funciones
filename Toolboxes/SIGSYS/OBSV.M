function ob = obsv(a,c)
%OBSV	Form observability matrix.
%	OBSV(A,C) returns the observability matrix.
%	Ob = [C; CA; CA^2 ...]
%
%	See also: OBSVF.

%	Copyright (c) 1986-93 by the MathWorks, Inc.

[m,n] = size(a);
ob = c;
for i=1:n-1
	ob = [c; ob*a];
end

