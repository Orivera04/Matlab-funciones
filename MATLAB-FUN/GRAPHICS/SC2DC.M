function [xd,yd] = sc2dc(xs,ys)
%SC2DC	Figure-coordinate to data-coordinate conversion.
%       SC2DC is obsolete, but provided for upward compatibility from
%       MATLAB 3.5.
%
% 	[Xd,Yd] = SC2DC(Xs,Ys) converts vectors or matrices Xs and Ys from 
% 	figure-coordinates to data-coordinates.  In figure-coordinates, 
% 	(0.0,0.0) is the lower-left corner of the figure and (1.0,1.0) is
% 	the upper-right corner.  For a 2-D plot, (Xmin,Ymin) is the
% 	lower-left corner of the axis box and (Xmax,Ymax) is the upper-
% 	right corner in data coordinates.  [Xmin Xmax Ymin Ymax] are the
% 	current axis settings as returned by AXIS.
%
% 	See also DC2SC.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

disp('This usage of sc2dc is obsolete and will be eliminated in future')
disp('versions.  Please use data coordinates instead.')
v = axis;
axpos = get(gca,'position');
xd = v(1) + (xs-axpos(1))*(v(2)-v(1))/axpos(3);
yd = v(3) + (ys-axpos(2))*(v(4)-v(3))/axpos(4);
