function [zi,weights] = interp3(x,y,z,xi,yi,weights)
%INTERP3 2-D biharmonic data interpolation and gridding.
%	ZI = INTERP3(X,Y,Z,XI,YI) uses biharmonic interpolation to
%	find ZI, the values of the underlying 2-D function in Z at the points
%	in matrices XI and YI.  Matrices X and Y specify the points at which 
%	the data Z is given.  X and Y can also be vectors specifying the 
%	abscissae for the matrix Z as for MESHGRID. In both cases, X
%	and Y must be equally spaced and monotonic.
%
%	If X, Y, and Z are all vectors, INTERP3 interpolates within the
%	data given by the (possibly irregularly spaced) ordered triplets
%	(X,Y,Z) to return matrix ZI.
%
%	ZI = INTERP3(Z,M,N) returns an M-by-N matrix ZI whose values
%	are interpolated within matrix Z.
%
%	[ZI,WEIGHTS]=INTERP3(X,Y,Z,XI,YI) also returns the computed
%	interpolation WEIGHTS, which can be reused as follows:
%	INTERP3(X,Y,Z,XI,YI,WEIGHTS) uses the given WEIGHTS vector,
%	instead of recalculating them from X, Y, and Z.
%
%	INTERP4 and INTERP5 are much faster than INTERP3 for
%	data interpolation and should be used unless irregularly
%	spaced vector triplet gridding is required.
%
%	See also INTERP4, INTERP5, INTERP2, SPLINE, INTERP1.

%	Copyright (c) 1984-94 by The MathWorks, Inc.
%	Charles R. Denham, Revised by Clay M. Thompson 7-29-91.

% 	Reference:  David T. Sandwell, Biharmonic spline
%	interpolation of GEOS-3 and SEASAT altimeter
%	data, Geophysical Research Letters, 2, 139-142,
%	1987.  Describes interpolation using value or
%	gradient of value in any dimension.

if nargin < 3
  error('Not enough input arguments.');

elseif nargin == 3
   rows = y; cols = z;
   z = x;
   [xi,yi] = meshgrid([0:rows-1]./(rows-1),[0:cols-1]./(cols-1));
   [m,n] = size(z);
   [x, y] = meshgrid([0:m-1]./(m-1),[0:n-1]./(n-1));

elseif nargin == 4
  error('Not enough or too many input arguments.')

end
disp('This usage of interp3 is obsolete and will be eliminated')
disp('in future versions. Please use griddata(x,y,z,xi,yi) instead.')

if prod(size(x)) ~= prod(size(z))
   if length(x(:)) .* length(y(:)) == prod(size(z))
      [x, y] = meshgrid(x, y);
     else
      error('Sizes of x, y, and z must match.')
   end
end

if size(xi) ~= size(yi)
  error('The size of XI and YI must be the same.');
end

xy = x(:) + y(:)*sqrt(-1);

% Determine weights for interpolation
if nargin < 6
   d = xy * ones(1,length(xy));
   d = abs(d - d.');
   mask = find(d == 0);
   d(mask) = ones(length(mask),1);
   g = (d.^2) .* (log(d)-1);   % Green's function.
   g(mask) = zeros(length(mask),1); % Value of Green's function at zero 
   weights = g \ z(:);
end

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
