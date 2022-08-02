function [xs,ys] = dc2sc(xd,yd)
%DC2SC	Data-coordinate to figure-coordinate conversion.
%	DC2SC is obsolete, but provided for upward compatibility from
%	MATLAB 3.5.
%
% 	[Xs,Ys] = DC2SC(Xd,Yd) converts vectors or matrices Xd and Yd from 
% 	data-coordinates to normalized figure coordinates.  In 
%	figure-coordinates, (0.0,0.0) is the lower-left corner of the figure
%	and (1.0,1.0) is the upper-right corner.  For a 2-D plot, (Xmin,Ymin)
%	is the lower-left corner of the axis box and (Xmax,Ymax) is the upper-
% 	right corner in data coordinates.  [Xmin Xmax Ymin Ymax] are the
% 	current axis settings as returned by AXIS. 
%
% 	See also SC2DC.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

disp('This usage of dc2sc is obsolete and will be eliminated in future')
disp('versions.  Please use normalized coordinates instead.')
v = axis;
axpos = get(gca,'position');
xs = axpos(1) + (xd-v(1))*axpos(3)/(v(2)-v(1));
ys = axpos(2) + (yd-v(3))*axpos(4)/(v(4)-v(3));

