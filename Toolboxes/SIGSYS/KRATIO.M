function a = kratio(m)
%KRATIO	Utility function for use with ELLIP.
%	KRATIO is a function used to calculate the zeros of an
%	elliptic filter.  It is used with FMINS to find a
%	parameter m satisfying ellipke(m)/ellipke(1-m) = krat.

%	Copyright (c) 1984-94 by The MathWorks, Inc.
%       $Revision: 1.5 $  $Date: 1994/01/25 17:59:23 $

global ELLIP_KRAT;
krat = ELLIP_KRAT;
% to ensure we don't call ellipke(1) which is inf on non-ieee machines
% and that we only call with positive m.
m = min(1,max(m,0));
if abs(m) > eps(1) & abs(m)+eps(1) < 1
	k = ellipke([m,1-m]);
	r = k(1)./k(2) - krat;
elseif abs(m) <= eps(1)	% m==0
	r = -krat;
else	% m==1 => r == inf, but can't for non-ieee machines
	r = 1e20;
end
a = abs(r);
