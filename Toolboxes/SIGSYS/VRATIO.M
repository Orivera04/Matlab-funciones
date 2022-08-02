function v = vratio(u)
%VRATIO	Utility function for use with ELLIP.
%	VRATIO is a function used to calculate the poles of an
%	elliptic filter.  It finds a u so sn(u)/cn(u) = 1/epsilon,
%	with parameter mp.

%	Copyright (c) 1984-94 by The MathWorks, Inc.
%       $Revision: 1.4 $  $Date: 1994/01/25 18:00:06 $

%	global information - 1/epsilon, the value s/c should attain
%			     with parameter mp.

global ELLIP_EPS ELLIP_MP;
mp = ELLIP_MP;
ineps = ELLIP_EPS;
[s,c] = ellipj(u,mp);
v = abs(ineps - s/c);

