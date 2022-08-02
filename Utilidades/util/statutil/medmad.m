function y = medmad(x, dim)
%MEDMAD Median absolute deviation from the median.
%
%   For vectors, MEDMAD(X) is the median absolute deviation from the median of
%   the elements in X, i.e., MEDIAN(ABS(X - MEDIAN(X))).
%
%   For matrices, MEDMAD(X) is a row vector containing the medmad value of each
%   column.
%
%   In general, MEDMAD(X) is the medmad value of the elements along the first
%   non-singleton dimension of X.
%
%   MEDMAD(X,DIM) is the medmad value along the dimension DIM of X.
%
%   For symmetric probability distributions, the theoretical medmad value
%   equals one half the inter-quartile range.
%
%   See also MEAN, STD, MIN, MAX, COV.

%   Author:      Peter J. Acklam
%   Time-stamp:  2003-11-04 10:53:42 +0100
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

   % degenerate cases
   if isempty(x) | n == 1
      sy = sx;
      if dim <= dx
         sy(dim) = 1;
      end
      y = zeros(sy);
      return;
   end

   % compute median along dimension `dim'
   m = median(x, dim);

   % replicate median along dimension `dim'
   r = ones(1, dx);
   r(dim) = n;
   m = repmat(m, r);

   % compute the absolute deviation from the median
   y = abs(x - m);

   % compute the median of along dimension `dim'
   y = median(y, dim);


   return


   % Alternative implementation:

   % permute and reshape so DIM becomes the row dimension of a 2-D array
   perm = 1:dx;
   perm([1 dim]) = [dim 1];
   x = reshape(permute(x, perm), [n prod(sx)/n]);

   % compute the median and replicate it
   m = median(x, 1);
   m = repmat(m, [n 1]);

   % subtract the median, take absolute values, and compute median of the
   % result
   y = abs(x - m);
   y = median(y, 1);

   % reshape and permute back
   sy = sx;
   sy(dim) = 1;
   y = permute(reshape(y, sy(perm)), perm);

   return
