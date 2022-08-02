function [cmin, cmax] = caxis(arg)
%CAXIS	Pseudocolor axis scaling.
%	CAXIS(V), where V is the two element vector [cmin cmax], sets manual
%	scaling of pseudocolor for the SURFACE and PATCH objects created by
%	commands like MESH, PCOLOR, and SURF.  cmin and cmax are assigned
%	to the first and last colors in the current colormap.  Colors for PCOLOR
%	and SURF are determined by table lookup within this range.  Values
%	outside the range are clipped by making them transparent.
%	CAXIS('auto') sets axis scaling back to autoranging.
%	CAXIS, by itself, returns the two element row vector containing the
%	[cmin cmax] currently in effect.
%
%	CAXIS is an M-file that sets the axes properties CLim and CLimMode.
%
%	See also COLORMAP, AXES, AXIS.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

ax = gca;

if(nargin == 0)
	cmin = get(ax,'CLim');
	if(nargout == 2)
		cmax = cmin(2); cmin = cmin(1);
	end
else
	if(isstr(arg))
		if(strcmp(arg, 'auto'))
			set(ax,'CLimMode','auto');
		else
			error('Unknown command option')
		end
	else
		[r c] = size(arg);
		if(r * c == 2)
			set(ax,'CLim',arg);
		else
			error('Must be two element row vector.')
		end
	end
end
