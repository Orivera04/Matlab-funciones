function [xx,yy,zz] = cylinder(r,n)
%CYLINDER Generate cylinder.
%	[X,Y,Z] = CYLINDER(R,N) forms the unit cylinder based on the generator
%	curve in the vector R. Vector R contains the radius at equally
%	spaced points along the unit height of the cylinder. The cylinder
%  	has N points around the circumference. SURF(X,Y,Z) displays the
%  	cylinder.
%
%  	[X,Y,Z] = CYLINDER(R), and [X,Y,Z] = CYLINDER default to N = 20
%  	and R = [1 1].
%
%  	Omitting output arguments causes the cylinder to be displayed with
%  	a SURF command and no outputs to be returned.
%
%  	See also SPHERE.

%	Clay M. Thompson 4-24-91, CBM 8-21-92.
%	Copyright (c) 1984-94 by The MathWorks, Inc.

if nargin < 2, n = 20; end
if nargin < 1, r = [1 1]'; end
r = r(:); % Make sure r is a vector.
m = length(r); if m==1, r = [r;r]; m = 2; end
theta = (0:n)/n*2*pi;
sintheta = sin(theta); sintheta(n+1) = 0;

x = r * cos(theta);
y = r * sintheta;
z = (0:m-1)'/(m-1) * ones(1,n+1);

if nargout == 0
    surf(x,y,z)
else
    xx = x; yy = y; zz = z;
end
