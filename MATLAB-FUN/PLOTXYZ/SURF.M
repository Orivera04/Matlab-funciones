function h = surf(x,y,z,c)
%SURF	3-D shaded surface graph.
%	SURF(X,Y,Z,C) plots the colored parametric surface defined by
%	four matrix arguments.  The view point is specified by VIEW.
%	The axis labels are determined by the range of X, Y and Z,
%	or by the current setting of AXIS.  The color scaling is determined
%	by the range of C, or by the current setting of CAXIS.  The scaled
%	color values are used as indices into the current COLORMAP.
%	The shading model is set by SHADING.
%
%	SURF(X,Y,Z) uses C = Z, so color is proportional to surface height.
%
%	SURF(x,y,Z) and SURF(x,y,Z,C), with two vector arguments replacing
%	the first two matrix arguments, must have length(x) = n and
%	length(y) = m where [m,n] = size(Z).  In this case, the vertices
%	of the surface patches are the triples (x(j), y(i), Z(i,j)).
%	Note that x corresponds to the columns of Z and y corresponds to
%	the rows.
%
%	SURF(Z) and SURF(Z,C) use x = 1:n and y = 1:m.  In this case,
%	the height, Z, is a single-valued function, defined over a
%	geometrically rectangular grid.
%
%	SURF returns a handle to a SURFACE object.
%
% 	AXIS, CAXIS, COLORMAP, HOLD, SHADING and VIEW set figure, axes, and 
% 	surface properties which affect the display of the surface.
%
% 	See also SURFC, SURFL, MESH.

%-------------------------------
%	Additional details:
%
%	If the NextPlot axis property is REPLACE (HOLD is off), SURF resets 
%	all axis properties, except Position, to their default values
%	and deletes all axis children (line, patch, surf, image, and 
%	text objects).

%	Copyright (c) 1984-94 by The MathWorks, Inc.

%	J.N. Little 1-5-92

cax = newplot;

if nargin == 0
	error('Not enough input arguments.')

elseif nargin == 1
	if min( size( x ) ) == 1
		error('Input argument must be a matrix not a vector or a scalar')
	else
		hh = surface(x);
	end

elseif nargin == 2
	hh = surface(x,y);

elseif nargin == 3
	hh = surface(x,y,z);

elseif nargin == 4
	hh = surface(x,y,z,c);

else
	error('Too many input arguments.')

end

next = lower(get(cax,'NextPlot'));
if ~ishold
	view(3);
end
if nargout == 1
	h = hh;
end
