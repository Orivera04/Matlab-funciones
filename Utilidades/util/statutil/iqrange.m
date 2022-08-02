function y = iqrange(x, varargin)
%IQRANGE Interquartile range.
%
%   For vectors, IQRANGE(X) is the interquartile range of X.
%
%   For matrices, IQRANGE(X) is a row vector with the interquartile range of
%   each column.
%
%   In general, IQRANGE(X) is the interquartile range along the first
%   non-singleton dimension.
%
%   IQRANGE(X, DIM) is the interquartile range along dimension DIM.
%
%   The interquartile range is the difference between the 3rd and 1st
%   quartiles, i.e., the 75% and 25% quantiles.

%   Author:      Peter J. Acklam
%   Time-stamp:  2002-03-03 13:45:49 +0100
%   E-mail:      pjacklam@online.no
%   URL:         http://home.online.no/~pjacklam

   error(nargchk(1, 2, nargin));

   q1 = quantile(x, 0.25, varargin{:});
   q3 = quantile(x, 0.75, varargin{:});
   y = q3 - q1;
