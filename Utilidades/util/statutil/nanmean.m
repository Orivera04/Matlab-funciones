function y = nanmean(x, dim)
%NANMEAN Mean of elements ignoring NaNs.
%
%   For vectors, NANMEAN(X) is the mean of the elements in X, ignoring NaNs,
%   i.e., MEAN(X(~ISNAN(X))).
%
%   For matrices, NANMEAN(X) is a row vector containing the NANMEAN value of
%   each column.
%
%   In general, NANMEAN(X) is the NANMEAN value of the elements along the
%   first non-singleton dimension of X.
%
%   NANMEAN(X, DIM) is the NANMEAN value along the dimension DIM of X.
%
%   See also MEAN, STD, MIN, MAX, COV.

%   Author:      Peter J. Acklam
%   Time-stamp:  2003-11-04 10:14:28 +0100
%   E-mail:      pjacklam@online.no
%   URL:         http://home.online.no/~pjacklam

   nargsin = nargin;
   error(nargchk(1, 2, nargsin));

   sx = size(x);
   dx = ndims(x);

   % get first non-singleton dimension, or 1 if none found
   if nargsin < 2
      k = find(sx ~= 1);
         if isempty(k)
         dim = 1;
      else
         dim = k(1);
      end
   else
      if any(size(dim) ~= 1) | dim < 1 | dim ~= round(dim)
         error('Dimension must be a scalar positive integer.');
      end
   end

   n = size(x, dim);

   % degenerate case
   if isempty(x)
      sy = sx;
      if dim <= dx
         sy(dim) = 1;
      end
      y = zeros(sy);
      return;
   end

   % replace NaNs with zeros
   i = isnan(x);
   x(i) = 0;

   % compute sum along dimension `dim'
   s = sum(x, dim);

   % get number of non-NaN values along dimension `dim'
   n = sum(~i, dim);

   % avoid dividing by zero
   s(n == 0) = 1;

   y = s ./ n;
