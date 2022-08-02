function yi = interp1(x,y,xi,method)
%INTERP1 1-D data interpolation (table lookup).
%	YI = INTERP1(X,Y,XI) returns vector YI containing elements
%   	corresponding to the elements of XI and determined by interpolation
%   	within vectors X and Y.
%
%	Interpolation is the same operation as "table lookup".  Described in
%	"table lookup" terms, the "table" is [X,Y] and INTERP1 "looks-up"
%	the elements of XI in X, and, based upon their location, returns
%	values YI interpolated within the elements of Y.
%
%	INTERP1 performs multiple output table lookup if Y is a matrix.
%	If Y is a matrix with length(X) rows, and N columns, INTERP1
%	returns a length(XI)-by-N matrix YI containing the multi-output 
%	table lookup results.
%
%	By default, INTERP1 uses linear interpolation.
%	YI = INTERP1(X,Y,XI,'method') specifies alternate methods.
%	Available methods are:
%
%	  'linear' - linear interpolation
%	  'spline' - cubic spline interpolation
%	  'cubic' - cubic interpolation
%
%	All the interpolation methods require that X be monotonic. The
%	'cubic' method also requires that the points in X be equally-spaced.
%
%	For example, generate a coarse sine curve and interpolate over a
%	finer abscissa:
%	                 x = 0:10; y = sin(x);
%	                 xi = 0:.25:10;
%	                 yi = interp1(x,y,xi);
%	                 plot(x,y,'o',xi,yi)
%
%	See also INTERPFT, INTERP2, GRIDDATA.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

error(nargchk(2,4,nargin));

% Trap call to old interp1, called interpft
if nargin==2
	disp('This usage of interp1(x,n) is obsolete and will be eliminated')
	disp('in future versions. Please use interpft(x,n) instead.')
	yi = interpft(x,y);
	return
end

% Check the arguments.
if nargin<4,
  method = 'linear';
end

if ~isstr(method),
  error('METHOD must be one of the strings: ''linear'',''spline'',''cubic''.');
end

if min(size(x))>1, 
  error('X must be a vector.'); 
else
  x = x(:);
end

if min(size(y))==1, y = y(:); end % Make sure y is a vector.

[m,n] = size(y);
if length(x)~=m,
  error('X must have the same number of elements as the rows of Y.');
end

if method(1)=='l', % Linear interpolation
  yi = table1([x,y],xi);

elseif method(1)=='s', % Spline interpolation
  xi = xi(:);
  yi = zeros(length(xi),n);
  for i=1:n,
    yi(:,i) = spline(x,y(:,i),xi);
  end

elseif method(1)=='c', % Cubic interpolation
  yi = icubic(x,y,xi);

else
  error([method,' is an invalid method.']);

end
  
