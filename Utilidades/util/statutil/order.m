function [i, y] = order(x, dim)
%ORDER  Order statistics.
%
%   For vectors, ORDER(X) is a permutation which rearranges the elements of
%   X into ascending order.
%
%   For matrices, ORDER(X) performs ORDER on each column.
%
%   In general, ORDER(X) performs ORDER along the first non-singleton
%   dimension.
%
%   ORDER(X, DIM) performs ORDER along dimension DIM.
%
%   This is a MATLAB version of the R `order' function.
%
%   See also SORT, RANKS, QUANTILE.

%   Author:      Peter J. Acklam
%   Time-stamp:  2003-11-04 10:16:04 +0100
%   E-mail:      pjacklam@online.no
%   URL:         http://home.online.no/~pjacklam

   nargsin = nargin;
   error(nargchk(1, 2, nargsin));

   sx = size(x);                % size of `x'
   dx = ndims(x);               % number of dimensions in `x'

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

   % special case when `x' is empty
   if isempty(x)
      y = zeros(sx);
      return;
   end

   % permute and reshape so DIM becomes the row dimension of a 2-D array
   perm = 1:dx;
   perm([1, dim]) = [dim, 1];
   x = reshape(permute(x, perm), [n, prod(sx)/n]);

   % get the order
   [y, i] = sort(x, 1);

   % reshape and permute back
   si = sx;
   i = permute(reshape(i, si(perm)), perm);

   % reshape and permute back
   if nargout > 1
      sy = si;
      y = permute(reshape(y, sy(perm)), perm);
   end
