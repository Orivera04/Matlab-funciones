function B=sph2cyl(A)
%SPH2CYL  Transform spherical to cylindrical coordinates.
%   T = SPH2CART(S) transforms the scalar function S
%   in spherical coordinates to cylindrical coordinates,
%   where T is a scalar function.
%
%   See also CART2SPH, CART2CYL, CYL2CART, CYL2SPH, SPH2CART.

% Copyright (c) 2001-04-17, B. Rasmus Anthin.

B=cart2cyl(sph2cart(A));