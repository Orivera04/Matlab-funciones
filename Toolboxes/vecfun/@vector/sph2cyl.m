function B=sph2cyl(A)
%SPH2CYL  Transform spherical to cylindrical coordinates.
%   W = SPH2CART(V) transforms the vector function V
%   in spherical coordinates to cylindrical coordinates,
%   where W is a vector function.
%
%   See also CART2SPH, CART2CYL, CYL2CART, CYL2SPH, SPH2CART.

% Copyright (c) 2001-04-17, B. Rasmus Anthin.

B=cart2cyl(sph2cart(A));