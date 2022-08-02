function w = triang(n)
%TRIANG	TRIANG(N) returns the N-point triangular window.

%	Copyright (c) 1984-94 by The MathWorks, Inc.
%       $Revision: 1.4 $  $Date: 1994/01/25 18:00:05 $

if rem(n,2)
	% It's an odd length sequence
	w = 2*(1:(n+1)/2)/(n+1);
	w = [w w((n-1)/2:-1:1)]';
else
	% It's even
	w = (2*(1:(n+1)/2)-1)/n;
	w = [w w(n/2:-1:1)]';
end

