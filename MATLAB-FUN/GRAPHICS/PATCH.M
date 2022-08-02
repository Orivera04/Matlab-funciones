%PATCH	Create patch low-level objects.
% 	PATCH(X,Y,C) adds the "patch" or filled 2-D polygon defined by 
%	vectors X and Y to the current axes. C specifies the color 
%	index into the colormap. If it is a scalar, it simply specifies
%	the color of the polygon ("flat" coloring). If it is a vector the
%	same length as X and Y, it specifies the color of each vertex and
%	bilinear interpolation is used to determine the interior color of
%	the polygon ("interpolated" coloring).
%
%	If C is a string, the polygon is filled with 'color'.  
%	'color' can be 'r','g','b','c','m','y', 'w', or 'k'.
%
%	If X, Y, and C are matrices the same size, one patch per column
%	is added. In this case, C is a row vector for "flat" polygon
%	colors, and C is a matrix for "interpolated" polygon colors.
%
%	PATCH sets its FaceColor property to 'flat', 'interp', or a
%	colorspec depending upon the value of the C matrix.
%
%	PATCH(X,Y,Z,C) creates patches in 3-D coordinates.
%
%	PATCH returns a column vector of handles to PATCH objects, one
%	handle per patch. PATCHes are children of AXES objects.
%
%	The X,Y,C triple (X,Y,Z,C quad for 3-D) can be followed by 
%	parameter/value pairs to specify additional properties of the
%	patches. The X,Y,Z triple (X,Y,Z quad for 3-D) can be omitted
%   	entirely, and all properties specified using parameter/value
%   	 pairs.
%
%       Execute GET(H), where H is a patch handle, to see a list of patch
%       object properties and their current values. Execute SET(H) to see
%       a list of patch object properties and legal property values.
%
% 	See also LINE, TEXT, FILL, FILL3.

%	Copyright (c) 1984-94 by The MathWorks, Inc.
%	Built-in function.
