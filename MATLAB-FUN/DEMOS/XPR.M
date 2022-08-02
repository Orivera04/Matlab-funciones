function  w = xpr(xy,t,u)
%XPR	 Radial coordinate of t-point of xy-curve rotated through angle u.
%	XPR is a helper function used by TUBE.

%       C. Henry Edwards, University of Georgia. 6-20-93.
%
%	Copyright (c) 1984-94 by The MathWorks, Inc.

[xt,yt] = feval(xy,t);

w = xt.*cos(u) - yt.*sin(u);
