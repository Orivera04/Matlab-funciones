function zi = interp2(x,y,z,xi,yi,method)
%INTERP2 2-D data interpolation (table lookup).
%	ZI = INTERP2(X,Y,Z,XI,YI) returns matrix ZI containing elements
%	corresponding to the elements of XI and YI and determined by 
%	interpolation within the 2-D function described by matrices X, Y, 
%	and Z.  Out of range values are returned as NaN.
%
%	X can be a row vector, in which case the elements are assumed to 
%	apply to the columns of Z. Similarly, Y can be a column vector
%	and its elements are assumed to apply across the rows of Z.
%
%	Interpolation is the same operation as "table lookup".  Described in
%	"table lookup" terms, the "table" is TAB = [NaN,Y; X,Z] and INTERP2 
%	"looks-up" the elements of XI in X, YI in Y, and, based upon their 
%	location, returns values ZI interpolated within the elements of Z.
%
%	By default, INTERP2 uses bilinear interpolation.
%	ZI = INTERP2(X,Y,Z,XI,YI,'method') specifies alternate methods.
%	Available methods are:
%
%	  'linear' or 'bilinear' - bilinear interpolation
%	  'cubic'  or 'bicubic'  - bicubic interpolation
%	  'nearest'              - nearest neighbor interpolation
%
%	All the interpolation methods require that X and Y be monotonic
%	and plaid (as if they were created using MESHGRID).  Variable 
%	spacing is handled by mapping the given values in X,Y,XI, and YI
%	to an equally-spaced domain before interpolating.
%
%	See also INTERP1, MESHGRID, GRIDDATA.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

error(nargchk(3,6,nargin));

% Trap call to old interp2, but call interp1 with 'spline' instead
if nargin == 3 
	disp('This usage of interp2(x,y,xi) is obsolete and will be eliminated')
	disp('in future versions. Please use interp1(x,y,xi,''spline'') instead.')
end
if nargin == 4
	disp('This usage of interp2(x,y,xi,w) is obsolete and will be eliminated')
	disp('in future versions. Please use interp1(x,y,xi,''spline'') instead.')
end
if nargin==3, zi = interp1(x,y,z,'spline'); return, end
if nargin==4, zi = interp1(x,y,z,'spline'); return, end
  
% Check the arguments.
if nargin<6,
  method = 'linear';
end

if ~isstr(method),
  error('METHOD must be one of the strings: ''bilinear'', ''bicubic'', or ''nearest''.');
end

% Check arguments, map to equally-spaced domain if necessary.
[msg,x,y,z,xi,yi] = xyzchk(x,y,z,xi,yi,'map');
if ~isempty(msg), error(msg); end

method = [lower(method),'   ']; % Protect against short string

if method(1)=='l' | all(method(1:3)=='bil'), % bilinear interpolation.
  zi = interp4(x,y,z,xi,yi);

elseif method(1)=='c' | all(method(1:3)=='bic'), % bicubic interpolation
  zi = interp5(x,y,z,xi,yi);

elseif method(1)=='n', % Nearest neighbor interpolation
  zi = interp6(x,y,z,xi,yi);

else
  error([method,' is an invalid method.']);

end


