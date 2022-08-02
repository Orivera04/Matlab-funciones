function [x,y,z] = pol2cart(th,r,z);
%POL2CART Transform polar coordinates to Cartesian.
%	[X,Y] = POL2CART(TH,R) transforms data stored in polar
%	coordinates to Cartesian coordinates. If [M,N] = SIZE(TH), then
%	R must be also be the same size. TH must be in radians.
%       [X,Y,Z] = POL2CART(TH,R,Z) transforms data stored in cylindrical
%       coordinates to Cartesian coordinates. If [M,N] = SIZE(TH), then
%       R and Z must be the same size.
%
%	See also CART2SPH, CART2POL, SPH2CART.

%	L. Shure, 4-20-92.
%	Copyright (c) 1984-94 by The MathWorks, Inc.

x = r.*cos(th);
y = r.*sin(th);
