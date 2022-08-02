function F = interp4(arg1,arg2,arg3,arg4,arg5)
%INTERP4 2-D bilinear data interpolation.
%	ZI = INTERP4(X,Y,Z,XI,YI) uses bilinear interpolation to
%	find ZI, the values of the underlying 2-D function in Z at the points
%	in matrices XI and YI.  Matrices X and Y specify the points at which 
%	the data Z is given.  X and Y can also be vectors specifying the 
%	abscissae for the matrix Z as for MESHGRID. In both cases, X
%	and Y must be equally spaced and monotonic.
%
%	Values of NaN are returned in ZI for values of XI and YI that are 
%	outside of the range of X and Y.
%
%	If XI and YI are vectors, INTERP4 returns vector ZI containing
%	the interpolated values at the corresponding points (XI,YI).
%
%	ZI = INTERP4(Z,XI,YI) assumes X = 1:N and Y = 1:M, where
%	[M,N] = SIZE(Z).
%
%	ZI = INTERP4(Z,NTIMES) returns the matrix Z expanded by interleaving
%	bilinear interpolates between every element, working recursively
%	for NTIMES.  INTERP4(Z) is the same as INTERP4(Z,1).
%
%	This function needs about 4 times SIZE(XI) memory to be available.
%
%	See also INTERP2, INTERP5.

%	Copyright (c) 1984-94 by The MathWorks, Inc.
%	Clay M. Thompson 4-26-91, revised 7-3-91, 3-22-93 by CMT.

if nargin==1, % interp4(z), Expand Z
  [nrows,ncols] = size(arg1);
  s = 1:.5:ncols; sizs = size(s);
  t = (1:.5:nrows)'; sizt = size(t);
  s = s(ones(sizt),:);
  t = t(:,ones(sizs));

elseif nargin==2, % interp4(z,n), Expand Z n times
  [nrows,ncols] = size(arg1);
  ntimes = floor(arg2);
  s = 1:1/(2*ntimes):ncols; sizs = size(s);
  t = (1:1/(2*ntimes):nrows)'; sizt = size(t);
  s = s(ones(sizt),:);
  t = t(:,ones(sizs));

elseif nargin==3, % interp4(z,s,t), No X or Y specified.
  [nrows,ncols] = size(arg1);
  s = arg2; t = arg3;

elseif nargin==4,
  error('Wrong number of input arguments.');

elseif nargin==5, % interp4(x,y,z,s,t), X and Y specified.
  [nrows,ncols] = size(arg3);
  mx = prod(size(arg1)); my = prod(size(arg2));
  if any([mx my] ~= [ncols nrows]) & any(size(arg1)~=size(arg3) | ...
     size(arg2)~=size(arg3)), 
    error('The lengths of the X and Y vectors must match Z.');
  end
  s = 1 + (arg4-arg1(1))*((ncols-1)/(arg1(mx)-arg1(1)));
  t = 1 + (arg5-arg2(1))*((nrows-1)/(arg2(my)-arg2(1)));
  
end

if any([nrows ncols]<[2 2]), error('Z must be at least 2-by-2.'); end
if any(size(s)~=size(t)),
  error('XI and YI must be the same size.');
end

% Check for out of range values of s and set to 1
sout = find((s<1)|(s>ncols));
if length(sout)>0, s(sout) = ones(size(sout)); end

% Check for out of range values of t and set to 1
tout = find((t<1)|(t>nrows));
if length(tout)>0, t(tout) = ones(size(tout)); end

% Matrix element indexing
ndx = floor(t)+floor(s-1)*nrows;

% Compute intepolation parameters, check for boundary value.
d = find(s==ncols); 
s(:) = (s - floor(s));
if length(d)>0, s(d) = s(d)+1; ndx(d) = ndx(d)-nrows; end

% Compute intepolation parameters, check for boundary value.
d = find(t==nrows);
t(:) = (t - floor(t));
if length(d)>0, t(d) = t(d)+1; ndx(d) = ndx(d)-1; end
d = [];

% Now interpolate, reuse u and v to save memory.
if nargin==5,
  F =  ( arg3(ndx).*(1-t) + arg3(ndx+1).*t ).*(1-s) + ...
       ( arg3(ndx+nrows).*(1-t) + arg3(ndx+(nrows+1)).*t ).*s;
else
  F =  ( arg1(ndx).*(1-t) + arg1(ndx+1).*t ).*(1-s) + ...
       ( arg1(ndx+nrows).*(1-t) + arg1(ndx+(nrows+1)).*t ).*s;
end

% Now set out of range values to NaN.
if length(sout)>0, F(sout) = NaN*ones(size(sout)); end
if length(tout)>0, F(tout) = NaN*ones(size(tout)); end
