function b = bone(m)
%BONE	Gray-scale with a tinge of blue color map.
%	BONE(M) returns an M-by-3 matrix containing a "bone" colormap.
%	BONE, by itself, is the same length as the current colormap.
%
%	For example, to reset the colormap of the current figure:
%
%	          colormap(bone)
%
%	See also HSV, GRAY, HOT, COOL, COPPER, PINK, FLAG, 
%	COLORMAP, RGBPLOT.

%	C. Moler, 5-11-91, 8-19-92.
%	Copyright (c) 1984-94 by The MathWorks, Inc.

if nargin < 1, m = size(get(gcf,'colormap'),1); end
b = (7*gray(m) + fliplr(hot(m)))/8;
