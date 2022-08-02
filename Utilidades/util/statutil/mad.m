function y = mad(x, dim)
%MAD    Mean absolute deviation from the mean.
%
%   For vectors, MAD(X) is the mean absolute deviation from the mean of the
%   elements in X, i.e., MEAN(ABS(X - MEAN(X))).
%
%   For matrices, MAD(X) is a row vector containing the mad value of each
%   column.
%
%   In general, MAD(X) is the mad value of the elements along the first
%   non-singleton dimension of X.
%
%   MAD(X, DIM) is the mad value along the dimension DIM of X.
%
%   See also MEAN, STD, MIN, MAX, COV.

%   Author:      Peter J. Acklam
%   Time-stamp:  2003-11-04 10:55:28 +0100
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

   % compute mean along dimension `dim'
   m = sum(x, dim)/n;

   % replicate mean along dimension `dim'
   rep = ones(1, dx);
   rep(dim) = n;
   m = repmat(m, rep);

   % compute the absolute deviation from the mean
   y = abs(x - m);

   % compute the mean of along dimension `dim'
   y = sum(y, dim)/n;
