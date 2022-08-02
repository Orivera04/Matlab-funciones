function w = kaiser(nn,beta)
%KAISER	KAISER(N,beta) returns the BETA-valued N-point Kaiser window.

%	Author(s): L. Shure, 3-4-87
%	Copyright (c) 1984-94 by The MathWorks, Inc.
%	$Revision: 1.5 $  $Date: 1994/01/25 17:59:22 $

nw = round(nn);
bes = abs(besseli(0,beta));
odd = rem(nw,2);
xind = (nw-1)^2;
n = fix((nw+1)/2);
xi = (0:n-1) + .5*(1-odd);
xi = 4*xi.^2;
w = besseli(0,beta*sqrt(1-xi/xind))/bes;
w = abs([w(n:-1:odd+1) w])';
