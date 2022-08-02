function  w = z(xy,t,u)
%ZPR    z-coordinate of t-point of xy-curve rotated through angle u.
%       ZPR is a helper function used by TUBE.
 
%       C. Henry Edwards, University of Georgia. 6-20-93.
%
%	Copyright (c) 1984-94 by The MathWorks, Inc.

[xt,yt] = feval(xy,t);

w = xt.*sin(u) + yt.*cos(u);
