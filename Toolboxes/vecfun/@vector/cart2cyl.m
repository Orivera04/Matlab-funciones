function B=cart2cyl(A)
%CART2CYL  Transform Cartesian to cylindrical coordinates.
%   W = CART2CYL(V) transforms the vector function V
%   in Cartesian coordinates to cylindrical coordinates,
%   where W is a vector function.
%
%   See also CART2SPH, CYL2CART, CYL2SPH, SPH2CART, SPH2CYL.

% Copyright (c) 2001-04-17, B. Rasmus Anthin.

Ax=vec2sca(A,1);Ay=vec2sca(A,2);Az=vec2sca(A,3);
B=[cart2cyl(Ax) cart2cyl(Ay) cart2cyl(Az)];