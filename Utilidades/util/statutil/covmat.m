function S = covmat(X, Y)
%COVMAT Covariance matrix.
%
%   S = COVMAT(X, Y) returns the covariance matrix between the data in X
%   and Y.  If X is N-by-P and Y is N-by-Q, then then S is P-by-Q.
%
%   The variance matrix is calculated by the corrected two-pass algorithm
%   for improved accuracy, especially on large data sets.  A reference to
%   this algorithm is T. F. Chan, G. H. Golub, R. J.  LeVeque, 1983,
%   American Statistician, vol. 37, pp. 242-247.

%   Author:      Peter J. Acklam
%   Time-stamp:  2001-06-19 12:40:30 +0200
%   E-mail:      pjacklam@online.no
%   URL:         http://home.online.no/~pjacklam

   error(nargchk(2, 2, nargin));

   if ndims(X) ~= 2 | isempty(X) | ndims(Y) ~= 2 | isempty(Y)
      error('Inputs must be non-empty 2D matrices.');
   end

   % size of input matrix
   [n, p] = size(X);
   [m, q] = size(Y);

   if n ~= m
      error('Input matrices must have the same number of rows.');
   end

   if n == 1
      S = zeros(p, p);
   else
      X_mean = sum(X, 1)/n;                     % mean of X
      X_cent = X - X_mean(ones(n,1),:);         % centered values of X
      Y_mean = sum(Y, 1)/n;                     % mean of X
      Y_cent = Y - Y_mean(ones(n,1),:);         % centered values of X

      sum_X_cent = sum(X_cent, 1);
      sum_Y_cent = sum(Y_cent, 1);

      S = (X_cent' * Y_cent - (sum_X_cent' * sum_Y_cent) / n) / (n - 1);
   end
