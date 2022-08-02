function r = ranks(x)
%RANKS  Sample ranks.
%
%   RANKS(X) returns the sample ranks of the values in X.  Ties result in
%   ranks being averaged.  X must be a vector.
%
%   This is a MATLAB version of the R `rank' function.
%
%   See also SORT, QUANTILE.

%   Author:      Peter J. Acklam
%   Time-stamp:  2003-11-10 22:29:31 +0100
%   E-mail:      pjacklam@online.no
%   URL:         http://home.online.no/~pjacklam

   error(nargchk(1, 1, nargin));

   n = length(x);
   [y, k] = sort(x);

   k(k) = 1:n;

   cmp = y(1:end-1) ~= y(2:end);
   if all(cmp(:))

      % there are no ties

      r = k;

   else

      % there are ties, so perform run-length encoding and get `len' and
      % `val' -- the run lengths and corresponding values

      i = [find(cmp) n];
      len = diff([0 i]);                   % length of each run

      j = len > 1;                         % find ties
      val = i;
      val(j) = val(j) - (len(j)-1)/2;

      % now perform run-length decoding on `len' and `val'

      i = cumsum([1 len]);
      j = zeros(1, i(end)-1);
      j(i(1:end-1)) = 1;
      r = val(cumsum(j));

      r = r(k);

   end
