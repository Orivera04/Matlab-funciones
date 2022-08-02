function B=cart2sph(A)
%CART2SPH  Transform Cartesian to spherical coordinates.
%   W = CART2SPH(V) transforms the vector function V
%   in Cartesian coordinates to spherical coordinates,
%   where W is a vector function.
%
%   See also CART2CYL, CYL2CART, CYL2SPH, SPH2CART, SPH2CYL.

% Copyright (c) 2001-04-17, B. Rasmus Anthin.

Ax=vec2sca(A,1);Ay=vec2sca(A,2);Az=vec2sca(A,3);
B=[cart2sph(Ax) cart2sph(Ay) cart2sph(Az)];