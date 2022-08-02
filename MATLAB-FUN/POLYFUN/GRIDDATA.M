function [xi,yi,zi] = griddata(x,y,z,xi,yi,method)
%GRIDDATA Data gridding.
%	ZI = GRIDDATA(X,Y,Z,XI,YI) returns matrix ZI containing elements
%	corresponding to the elements of matrices XI and YI and determined by
%	interpolation within the 2-D function described by the (usually)
%	nonuniformly-spaced vectors (X,Y,Z).
%
%	XI can be a row vector, in which case it specifies a matrix with
%	constant columns. Similarly, YI can be a column vector and it 
%	specifies a matrix with constant rows. 
%
%	[XI,YI,ZI] = GRIDDATA(X,Y,Z,XI,YI) returns the XI and YI formed
%	this way, which are the same as the matrices returned by MESHGRID.
%
%	GRIDDATA uses an inverse distance method.
%
%	See also INTERP2, INTERP1.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

%       Reference:  David T. Sandwell, Biharmonic spline
%       interpolation of GEOS-3 and SEASAT altimeter
%       data, Geophysical Research Letters, 2, 139-142,
%       1987.  Describes interpolation using value or
%       gradient of value in any dimension.

error(nargchk(5,5,nargin)) % Ignore method for now.

[msg,x,y,z,xi,yi] = xyzchk(x,y,z,xi,yi);

if length(msg)>0, error(msg); end
xy = x(:) + y(:)*sqrt(-1);

% Determine weights for interpolation
d = xy * ones(1,length(xy));
d = abs(d - d.');
mask = find(d == 0);
d(mask) = ones(length(mask),1);
g = (d.^2) .* (log(d)-1);   % Green's function.
g(mask) = zeros(length(mask),1); % Value of Green's function at zero
weights = g \ z(:);

[m,n] = size(xi);
zi = zeros(m,n);
jay = sqrt(-1);
xy = xy.';

% Evaluate at requested points (xi,yi).  Loop to save memory.
for i=1:m
  for j=1:n
    d = abs(xi(i,j)+jay*yi(i,j) - xy);
    mask = find(d == 0);
    if length(mask)>0, d(mask) = ones(length(mask),1); end
    g = (d.^2) .* (log(d)-1);   % Green's function.
    % Value of Green's function at zero
    if length(mask)>0, g(mask) = zeros(length(mask),1); end
    zi(i,j) = g * weights;
  end
end


if nargout<=1,
  xi = zi;
end

