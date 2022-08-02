function B=cyl2sph(A)
%CYL2SPH  Transform cylindrical to spherical coordinates.
%   W = CYL2SPH(V) transforms the vector function V
%   in cylindrical coordinates to spherical coordinates,
%   where W is a vector function.
%
%   See also CART2CYL, CART2SPH, CYL2CART, SPH2CART, SPH2CYL.

% Copyright (c) 2001-04-17, B. Rasmus Anthin.

B=cart2sph(cyl2cart(A));