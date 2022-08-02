function F = interp6(arg1,arg2,arg3,arg4,arg5)
%INTERP6 2-D Nearest neighbor interpolation.
%	ZI = INTERP6(X,Y,Z,XI,YI) uses nearest neighbor interpolation to
%	find ZI, the values of the underlying 2-D function in Z at the points
%	in matrices XI and YI.  Matrices X and Y specify the points at which 
%	the data Z is given.  X and Y can also be vectors specifying the 
%	abscissae for the matrix Z as for MESHGRID. In both cases, X
%	and Y must be equally spaced and monotonic.
%
%	Values of NaN are returned in ZI for values of XI and YI that are 
%	outside of the range of X and Y.
%
%	If XI and YI are vectors, INTERP6 returns vector ZI containing
%	the interpolated values at the corresponding points (XI,YI).
%
%	ZI = INTERP6(Z,XI,YI) assumes X = 1:N and Y = 1:M, where
%	[M,N] = SIZE(Z).
%
%	F = INTERP6(Z,NTIMES) returns the matrix Z expanded by interleaving
%	interpolates between every element.  INTERP6(Z) is the same as 
%	INTERP6(Z,1).
%
%	See also INTERP2, INTERP4, INTERP5.

%	Copyright (c) 1984-94 by The MathWorks, Inc.
%	$Revision: 1.7 $  $Date: 1994/01/25 15:59:14 $
%	Clay M. Thompson 4-26-91, revised 7-3-91 by CMT.

if nargin==1, % interp6(z), Expand Z
  [nrows,ncols] = size(arg1);
  u = ones(2*nrows-1,1)*(1:.5:ncols);
  v = (1:.5:nrows)'*ones(1,2*ncols-1);

elseif nargin==2, % interp6(z,n), Expand Z n times
  [nrows,ncols] = size(arg1);
  ntimes = floor(arg2);
  u = ones(2*ntimes*(nrows-1)+1,1)*(1:1/(2*ntimes):ncols);
  v = (1:1/(2*ntimes):nrows)'*ones(1,2*ntimes*(ncols-1)+1);

elseif nargin==3, % interp6(z,u,v)
  [nrows,ncols] = size(arg1);
  u = arg2; v = arg3;

elseif nargin==4,
  error('Wrong number of input arguments.');

elseif nargin==5, % interp6(x,y,z,u,v), X and Y specified.
  [nrows,ncols] = size(arg3);
  mx = prod(size(arg1)); my = prod(size(arg2));
  if any([mx my] ~= [ncols nrows]) & (size(arg1)~=size(arg3) |   ...
    size(arg2)~=size(arg3)), 
    error('The lengths of the X and Y vectors must match Z.');
  end
  u = 1 + (arg4-arg1(1))*((ncols-1)/(arg1(mx)-arg1(1)));
  v = 1 + (arg5-arg2(1))*((nrows-1)/(arg2(my)-arg2(1)));

end

if size(u)~=size(v), error('XI and YI must be the same size.'); end

% Check for out of range values of u and set to 1
uout = (u<.5)|(u>=ncols+.5);
nuout = sum(uout(:));
if any(uout(:)), u(uout) = ones(nuout,1); end

% Check for out of range values of v and set to 1
vout = (v<.5)|(v>=nrows+.5);
nvout = sum(vout(:));
if any(vout(:)), v(vout) = ones(nvout,1); end

% Interpolation parameters
s = (u - round(u));  t = (v - round(v));
u = round(u); v = round(v);

% Now interpolate
ndx = v+(u-1)*nrows;
if nargin==5,
  F = arg3(ndx);
else
  F = arg1(ndx);
end

% Now set out of range values to NaN.
if any(uout(:)), F(uout) = NaN*ones(nuout,1); end
if any(vout(:)), F(vout) = NaN*ones(nvout,1); end
