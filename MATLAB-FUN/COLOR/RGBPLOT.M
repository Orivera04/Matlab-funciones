function rgbplot(map)
%RGBPLOT Plot color map.
%	RGBPLOT(MAP) plots a color map, i.e. an m-by-3 matrix which
%	is appropriate input for COLORMAP. The three columns of the
%	colormap matrix are plotted in red, green, and blue lines.
%
%	See also COLORMAP, RGB2HSV.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

if size(map,2) ~= 3
	error('Must be a 3-column colormap matrix.');
end
m = 1:size(map,1);
plot(m,map(:,1),'r-',m,map(:,2),'g-',m,map(:,3),'b-');
