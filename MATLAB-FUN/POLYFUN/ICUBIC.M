function F=icubic(x,y,u)
%ICUBIC Cubic Interpolation of a 1-D function.
%
%	YI=ICUBIC(Y,XI) returns the value of the 1-D function Y at the
%	points XI using cubic interpolation. length(YI)=length(XI). XI is
%	an index into the vector Y. Y is the value of the function
%	evaluated uniformly on a interval. If Y is a matrix, then
%	the interpolation is performed for each column of Y.
%
%	If Y is of length N then XI must contain values between 1 and N.
%	The value NaN is returned if this is not the case.
%
%	YI = ICUBIC(X,Y,XI) uses the vector X to specify the coordinates
%	of the underlying interval. X must be equally spaced and
%	monotonic. XI must lie within the coordinates in X.

%	Clay M. Thompson 7-4-91
%	Copyright (c) 1984-94 by The MathWorks, Inc.

%	Based on "Cubic Convolution Interpolation for Digital Image
%	Processing", Robert G. Keys, IEEE Trans. on Acoustics, Speech, and
%	Signal Processing, Vol. 29, No. 6, Dec. 1981, pp. 1153-1160.

if nargin==2,	% No X specified.
  u = y; y = x;

% Check for vector problem.  If so, make everything a column vector.
  if min(size(y))==1, y = y(:); end
  if min(size(u))==1, u = u(:); end
  [nrows,ncols] = size(y);

elseif nargin==3, % X specified.
  % Check for vector problem.  If so, make everything a column vector.
  if min(size(y))==1, y = y(:); end
  if min(size(x))==1, x = x(:); end
  if min(size(u))==1, u = u(:); end
  [nrows,ncols] = size(y);
  % Scale and shift u to be indices into Y.
  if (min(size(x))~=1), error('X must be a vector.'); end
  x = x(:);
  [m,n] = size(x);
  if m ~= nrows, 
    error('The length of X must match the number of rows of Y.');
  end
  u = 1 + (u-x(1))*((nrows-1)/(x(m)-x(1)));
  
else
  error('Wrong number of input arguments.');
end

if nrows<3, error('Y must have at least 3 rows.'); end
[m,n] = size(u); 
if n==1, u = u*ones(1,ncols); [m,n] = size(u); end	% Expand u 
if n~=ncols, error('The number of columns in XI and Y must match.'); end

% Check for out of range values of u and set to 1
uout = find((u<1)|(u>nrows));
nuout = length(uout);
if nuout>0, u(uout) = ones(nuout,1); end

% Interpolation parameters
s = (u - floor(u));
u = floor(u);
d = find(u==nrows); if length(d)>0, u(d) = u(d)-1; s(d) = s(d)+1; end

% Expand y so interpolation is valid at the boundary.
y = [3*y(1,:)-3*y(2,:)+y(3,:);y;3*y(nrows,:)-3*y(nrows-1,:)+y(nrows-2,:)];
nrows = nrows + 2;

% Now interpolate using computationally efficient algorithm.
s2 = s.*s; s3 = s.*s2;
ndx = u+ones(m,1)*[0:n-1]*nrows;
F     = y(ndx).*(-s3+2*s2-s) + y(ndx+1).*(3*s3-5*s2+2) + ...
	y(ndx+2).*(-3*s3+4*s2+s) + y(ndx+3).*(s3-s2);
F = F/2;

% Now set out of range values to NaN.
if nuout>0, F(uout) = NaN*ones(nuout,1); end

