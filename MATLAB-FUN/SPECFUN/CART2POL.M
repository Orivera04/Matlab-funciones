function [th,r,z] = cart2pol(x,y,z)
%CART2POL Transform Cartesian coordinates to polar.
%	[TH,R] = CART2POL(X,Y) transforms data stored in Cartesian
%	coordinates to polar coordinates. If [M,N] = SIZE(X), then
%	Y must be also be the same size. TH is returned in radians.
%	[TH,R,Z] = CART2POL(X,Y,Z) transforms data stored in Cartesian  
%	coordinates to cylindrical coordinates. If [M,N] = SIZE(X), then
%	Y and Z must be the same size.
%
%	See also CART2SPH, SPH2CART, POL2CART.

%	L. Shure, 4-20-92.
%	Copyright (c) 1984-94 by The MathWorks, Inc.

th = atan2(y,x);
r = sqrt(x.^2+y.^2);
