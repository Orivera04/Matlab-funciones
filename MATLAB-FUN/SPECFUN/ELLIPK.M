function k = ellipk(kind,m)
%ELLIPK	Complete elliptic integrals.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

if kind ~= 1
	error('Use ellipke for elliptic integrals of the second kind.')
end
disp('This usage of ellipk(kind,m) is obsolete and will be eliminated')
disp('in future versions. Please use ellipke(m) instead.')
k = ellipke(m);
