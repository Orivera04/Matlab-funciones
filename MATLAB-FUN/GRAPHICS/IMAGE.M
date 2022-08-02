%IMAGE	Display image (create image object).
% 	IMAGE(C) displays matrix C as an image.  Each element of C
%	specifies the color of a rectilinear patch in the image. The
%	elements of C are used as indices into the current COLORMAP
%	to determine the color.  If [M N] = SIZE(C), the axis limits
%	are [0.5 N+0.5 0.5 M+0.5] so that each element in C is centered
%	at integer coordinates ranging between 1 and M or N.
%
% 	IMAGE(X,Y,C), where X and Y are vectors, specifies the labeling of
% 	X- and Y-axes, but produces the same image as IMAGE(C). Only the
%	first and last elements of X and Y are used for the axis limits.
%	In this case, the first/last row of C is centered on the first/last
%	Y-value, and the first/last column of C is centered on the first/last
%	X-value, with approriate padding at the end to preserve the constant
%	spacing along the X and Y axes.
%
%	IMAGE returns a handle to an IMAGE object.
%
%	C or the X,Y,C triple can be followed by parameter/value
%	pairs to specify additional properties of the image.
%	C or the X,Y,C triple can be omitted entirely, and all
%	properties specified using parameter/value pairs.
%
%	IMAGE sets the YDir axis property to 'reverse', and the View
%	axis property to [0 90].  The image object will not render at other
%       View angles.  To get a similar effect to rotating an image, use
%       SURF with texture mapping or PCOLOR.
%
%       Execute GET(H), where H is an image handle, to see a list of image
%       object properties and their current values. Execute SET(H) to see a
%       list of image object properties and legal property values.
%
%   	See also COLORMAP, PCOLOR, SURF.

%	Copyright (c) 1984-94 by The MathWorks, Inc.
%	Built-in function.

