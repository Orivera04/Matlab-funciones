function newmap = brighten(map,beta)
%BRIGHTEN Brighten or darken color map.
%
%	BRIGHTEN(beta) replaces the current color map with a brighter
%	or darker map involving essentially the same colors.  The map is
%	brighter if 0 < beta <= 1 and darker if -1 <= beta < 0.
%
%	BRIGHTEN(beta), followed by BRIGHTEN(-beta) restores the
%	original map.
%   
%	map = BRIGHTEN(beta) returns a brighter or darker version of the
%	color map currently being used without changing the display.
%
%	newmap = BRIGHTEN(map,beta) returns a brighter or darker version
%	of the specified color map without changing the display.

%	CBM, 9-13-91, 2-6-92.
%	Copyright (c) 1984-94 by The MathWorks, Inc.

if nargin < 2, beta = map; map = colormap; end

if max(max(map)) > 1
	map = map/255;
end

if (beta > 1) | (beta < -1)
   error('Beta must be between -1 and 1.')
end

if beta > 0
   gamma = 1 - min(1,beta);
else
   gamma = 1/(1 + max(-1+eps,beta));
end

map = map.^gamma;

if nargout == 0
   colormap(map)
else
   newmap = map;
end

