function F = interp5(arg1,arg2,arg3,arg4,arg5)
%INTERP5 2-D bicubic data interpolation.
%	INTERP5(...) is the same as INTERP4(....) except that it uses
%	bicubic interpolation.
%	
%	This function needs about 7-8 times SIZE(XI) memory to be available.
%
%	See also INTERP4.

%	Copyright (c) 1984-94 by The MathWorks, Inc.
%	Clay M. Thompson 4-26-91, revised 7-3-91, 3-22-93 by CMT.

%	Based on "Cubic Convolution Interpolation for Digital Image
%	Processing", Robert G. Keys, IEEE Trans. on Acoustics, Speech, and
%	Signal Processing, Vol. 29, No. 6, Dec. 1981, pp. 1153-1160.

if nargin==1, % interp5(z), Expand Z
  [nrows,ncols] = size(arg1);
  s = 1:.5:ncols; sizs = size(s);
  t = (1:.5:nrows)'; sizt = size(t);
  s = s(ones(sizt),:);
  t = t(:,ones(sizs));

elseif nargin==2, % interp5(z,n), Expand Z n times
  [nrows,ncols] = size(arg1);
  ntimes = floor(arg2);
  s = 1:1/(2*ntimes):ncols; sizs = size(s);
  t = (1:1/(2*ntimes):nrows)'; sizt = size(t);
  s = s(ones(sizt),:);
  t = t(:,ones(sizs));

elseif nargin==3, % interp5(z,s,t), No X or Y specified.
  [nrows,ncols] = size(arg1);
  s = arg2; t = arg3;

elseif nargin==4,
  error('Wrong number of input arguments.');

elseif nargin==5, % interp5(x,y,z,s,t), X and Y specified.
  [nrows,ncols] = size(arg3);
  mx = prod(size(arg1)); my = prod(size(arg2));
  if any([mx my] ~= [ncols nrows]) & any(size(arg1)~=size(arg3) | ...
     size(arg2)~=size(arg3)), 
    error('The lengths of the X and Y vectors must match Z.');
  end
  s = 1 + (arg4-arg1(1))*((ncols-1)/(arg1(mx)-arg1(1)));
  t = 1 + (arg5-arg2(1))*((nrows-1)/(arg2(my)-arg2(1)));
  
end

if any([nrows ncols]<[3 3]), error('Z must be at least 3-by-3.'); end
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
ndx = floor(t)+floor(s-1)*(nrows+2);

% Compute intepolation parameters, check for boundary value.
d = find(s==ncols); 
s(:) = (s - floor(s));
if length(d)>0, s(d) = s(d)+1; ndx(d) = ndx(d)-nrows-2; end

% Compute intepolation parameters, check for boundary value.
d = find(t==nrows);
t(:) = (t - floor(t));
if length(d)>0, t(d) = t(d)+1; ndx(d) = ndx(d)-1; end
d = [];

if nargin==5,
  % Expand z so interpolation is valid at the boundaries.
  zz = zeros(size(arg3)+2);
  zz(1,2:ncols+1) = 3*arg3(1,:)-3*arg3(2,:)+arg3(3,:);
  zz(2:nrows+1,2:ncols+1) = arg3;
  zz(nrows+2,2:ncols+1) = 3*arg3(nrows,:)-3*arg3(nrows-1,:)+arg3(nrows-2,:);
  zz(:,1) = 3*zz(:,2)-3*zz(:,3)+zz(:,4);
  zz(:,ncols+2) = 3*zz(:,ncols+1)-3*zz(:,ncols)+zz(:,ncols-1);
  nrows = nrows+2; ncols = ncols+2;
else
  % Expand z so interpolation is valid at the boundaries.
  zz = zeros(size(arg1)+2);
  zz(1,2:ncols+1) = 3*arg1(1,:)-3*arg1(2,:)+arg1(3,:);
  zz(2:nrows+1,2:ncols+1) = arg1;
  zz(nrows+2,2:ncols+1) = 3*arg1(nrows,:)-3*arg1(nrows-1,:)+arg1(nrows-2,:);
  zz(:,1) = 3*zz(:,2)-3*zz(:,3)+zz(:,4);
  zz(:,ncols+2) = 3*zz(:,ncols+1)-3*zz(:,ncols)+zz(:,ncols-1);
  nrows = nrows+2; ncols = ncols+2;
end

% Now interpolate using computationally efficient algorithm.
t0 = ((2-t).*t-1).*t;
t1 = (3*t-5).*t.*t+2;
t2 = ((4-3*t).*t+1).*t;
t(:) = (t-1).*t.*t;
F     = ( zz(ndx).*t0 + zz(ndx+1).*t1 + zz(ndx+2).*t2 + zz(ndx+3).*t ) ...
        .* (((2-s).*s-1).*s);
ndx(:) = ndx + nrows;
F(:)  = F + ( zz(ndx).*t0 + zz(ndx+1).*t1 + zz(ndx+2).*t2 + zz(ndx+3).*t ) ...
        .* ((3*s-5).*s.*s+2);
ndx(:) = ndx + nrows;
F(:)  = F + ( zz(ndx).*t0 + zz(ndx+1).*t1 + zz(ndx+2).*t2 + zz(ndx+3).*t ) ...
        .* (((4-3*s).*s+1).*s);
ndx(:) = ndx + nrows;
F(:)  = F + ( zz(ndx).*t0 + zz(ndx+1).*t1 + zz(ndx+2).*t2 + zz(ndx+3).*t ) ...
       .* ((s-1).*s.*s);
F(:) = F/4;

% Now set out of range values to NaN.
if length(sout)>0, F(sout) = NaN*ones(size(sout)); end
if length(tout)>0, F(tout) = NaN*ones(size(tout)); end
