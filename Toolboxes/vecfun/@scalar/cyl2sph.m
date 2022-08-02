function B=cyl2sph(A)
%CYL2SPH  Transform cylindrical to spherical coordinates.
%   T = CYL2SPH(S) transforms the scalar function S
%   in cylindrical coordinates to spherical coordinates,
%   where T is a scalar function.
%
%   See also CART2CYL, CART2SPH, CYL2CART, SPH2CART, SPH2CYL.

% Copyright (c) 2001-04-17, B. Rasmus Anthin.

B=cart2sph(cyl2cart(A));