function map = colormap(arg)
%COLORMAP Set the color look-up table.
% 	COLORMAP(MAP) sets the current figure's colormap to MAP.
% 	COLORMAP('default') sets the current figure's colormap to
%	the root's default, whose factory setting is HSV.
% 	MAP = COLORMAP retrieves the current colormap. The values
%	are in the range from 0 to 1.
%
%	A color map matrix may have any number of rows, but it must have
%	exactly 3 columns.  Each row is interpreted as a color, with the
%	first element specifying the intensity of red light, the second 
%	green, and the third blue.  Color intensity can be specified on the
%	interval 0.0 to 1.0.
% 	For example, [0 0 0] is black, [1 1 1] is white, 
% 	[1 0 0] is pure red, [.5 .5 .5] is gray, and
%	[127/255 1 212/255] is aquamarine.
% 	
% 	Graphics objects that use pseudocolor  -- SURFACE and PATCH objects,
%	which are created by the functions MESH, SURF, and PCOLOR -- map
% 	a color matrix, C, whose values are in the range [Cmin, Cmax],
% 	to an array of indices, k, in the range [1, m].
% 	The values of Cmin and Cmax are either min(min(C)) and max(max(C)),
% 	or are specified by CAXIS.  The mapping is linear, with Cmin
% 	mapping to index 1 and Cmax mapping to index m.  The indices are
% 	then used with the colormap to determine the color associated
% 	with each matrix element.  See CAXIS for details.
% 
% 	Type HELP COLOR to see a number of useful colormaps.
%
%	COLORMAP is an M-file that sets the Colormap property of the current
%	figure.
%
% 	See also COLOR, HSV, CAXIS, SPINMAP, BRIGHTEN, RGBPLOT, FIGURE.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

if (nargin == 0)
    map = get(gcf, 'Colormap');
    return
end
if isstr(arg)
    if strcmp(arg,'default')
        set(gcf,'Colormap','default');
        return
    else
        arg = eval(arg);
    end
end
if ~isempty(arg)
	if (size(arg,2) ~= 3)
	    error('Colormap must have 3 columns: [R,G,B].');
	end
	if min(min(arg)) < 0 | max(max(arg)) > 1
	    error('Colormap must have values in [0,1].')
	end
end
set(gcf, 'Colormap', arg);
