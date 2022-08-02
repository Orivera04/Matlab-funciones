function [M, S, Xc] = meanvar(X)
%MEANVAR Mean and variance of a data set.
%
%   [M, S] = MEANVAR(X) returns the mean and variance of the data in X.  If
%   X is N-by-P, then M is 1-by-P and S is P-by-P.
%
%   [M, S, XC] = MEANVAR(X) also returns the centered values of X, which has
%   zero mean.  XC has the same size as X.

%   Author:      Peter J. Acklam
%   Time-stamp:  2001-06-19 12:40:30 +0200
%   E-mail:      pjacklam@online.no
%   URL:         http://home.online.no/~pjacklam

   error(nargchk(1, 1, nargin));
   if ndims(x) ~= 2
      error('Input must be a 2D array.');
   end

   [n, p] = size(X);                    % get size of input matrix
   M = sum(X, 1) / n;                   % mean of rows
   Xc = X - M(ones(n,1),:);             % centered values
   S  = (Xc' * Xc) / (n - 1);           % variance matrix
