function [xx,yy,zz] = sphere(n)
%SPHERE	Generate sphere.
%	[X,Y,Z] = SPHERE(N) generates three (n+1)-by-(n+1)
%	matrices so that SURF(X,Y,Z) produces a unit sphere.
%
%	[X,Y,Z] = SPHERE uses N = 20.
%
%	SPHERE(N) and just SPHERE graph the sphere as a SURFACE
%	and do not return anything.
%
%	See also CYLINDER.

%	Clay M. Thompson 4-24-91, CBM 8-21-92.
%	Copyright (c) 1984-94 by The MathWorks, Inc.

if nargin == 0, n = 20; end

% -pi <= theta <= pi is a row vector.
% -pi/2 <= phi <= pi/2 is a column vector.
theta = (-n:2:n)/n*pi;
phi = (-n:2:n)'/n*pi/2;
cosphi = cos(phi); cosphi(1) = 0; cosphi(n+1) = 0;
sintheta = sin(theta); sintheta(1) = 0; sintheta(n+1) = 0;

x = cosphi*cos(theta);
y = cosphi*sintheta;
z = sin(phi)*ones(1,n+1);

if nargout == 0
   surf(x,y,z)
else
   xx = x; yy = y; zz = z;
end
