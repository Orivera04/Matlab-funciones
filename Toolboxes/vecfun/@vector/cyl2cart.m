function B=cyl2cart(A)
%CYL2CART  Transform cylindrical to Cartesian coordinates.
%   W = CYL2CART(V) transforms the vector function V
%   in cylindrical coordinates to Cartesian coordinates,
%   where W is a vector function.
%
%   See also CART2CYL, CART2SPH, CYL2SPH, SPH2CART, SPH2CYL.

% Copyright (c) 2001-04-17, B. Rasmus Anthin.

Ax=vec2sca(A,1);Ay=vec2sca(A,2);Az=vec2sca(A,3);
B=[cyl2cart(Ax) cyl2cart(Ay) cyl2cart(Az)];