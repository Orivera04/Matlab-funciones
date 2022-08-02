function S = varmat(X)
%VARMAT Variance matrix.
%
%   S = VARMAT(X) returns the variance matrix of the data in X.  If X is
%   N-by-P, then S is P-by-P.
%
%   The variance matrix is calculated by the corrected two-pass algorithm
%   for improved accuracy, especially on large data sets.  A reference to
%   this algorithm is T. F. Chan, G. H. Golub, R. J.  LeVeque, 1983,
%   American Statistician, vol. 37, pp. 242-247.

%   Author:      Peter J. Acklam
%   Time-stamp:  2001-06-19 12:40:32 +0200
%   E-mail:      pjacklam@online.no
%   URL:         http://home.online.no/~pjacklam

   error(nargchk(1, 1, nargin));

   if ndims(X) ~= 2 | isempty(X)
      error('Input must be a non-empty 2D matrix.');
   end

   % size of input matrix
   [n, p] = size(X);

   if n == 1
      S = zeros(p, p);
   else
      X_mean = sum(X, 1)/n;                     % mean of input matrix
      X_cent = X - X_mean(ones(n,1),:);         % centered values
      sum_X_cent = sum(X_cent, 1);
      S = (X_cent' * X_cent - (sum_X_cent' * sum_X_cent) / n) / (n - 1);
   end
