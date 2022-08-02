function B=sph2cart(A)
%SPH2CART  Transform spherical to Cartesian coordinates.
%   W = SPH2CART(V) transforms the vector function V
%   in spherical coordinates to Cartesian coordinates,
%   where W is a vector function.
%
%   See also CART2SPH, CART2CYL, CYL2CART, CYL2SPH, SPH2CYL.

% Copyright (c) 2001-04-17, B. Rasmus Anthin.

Ax=vec2sca(A,1);Ay=vec2sca(A,2);Az=vec2sca(A,3);
B=[sph2cart(Ax) sph2cart(Ay) sph2cart(Az)];