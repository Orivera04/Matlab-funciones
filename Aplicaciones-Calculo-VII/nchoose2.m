function c = nchoose2(v, bool)
%NCHOOSE2 All combinations of N elements taken two at a time.
%
%   NCHOOSE2(V) where V is a vector of length N, produces a matrix with
%   N*(N-1)/2 rows and 2 columns.  Each row of the result has two of the
%   elements in the vector V.
%
%   NCHOOSE2(N, BOOL) where N is a scalar integer and BOOL is true, is the same
%   as NCHOOSE2(1:N) but faster.
%
%   NCHOOSE2(V) is much faster than NCHOOSEK(V, 2).
%
%   See also NCHOOSEK, PERMS.

%   Author:      Peter J. Acklam
%   Time-stamp:  2003-10-13 14:44:00 +0200
%   E-mail:      pjacklam@online.no
%   URL:         http://home.online.no/~pjacklam

   nargsin = nargin;

   % check number of input arguments
   error(nargchk(1, 2, nargsin));

   if nargsin < 2
      bool = 0;
   end

   if bool
      n = v;
      if any(size(n) ~= 1) | (n < 1)
         error('N must be a scalar positive integer.');
      end
   else
      if sum(size(v) > 1) > 1
         error('V must be a vector.');
      end
      n = length(v);
      if n < 2
         error('The vector V must have at least two elements.');
      end
   end

   [c(:,2), c(:,1)] = find(tril(ones(n), -1));

   if ~bool
      c = v(c);
   end
