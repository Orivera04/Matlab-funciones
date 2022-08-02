function y = truncdec(x, n)
%TRUNCDEC Truncate to a specified number of decimals.
%
%   Y = TRUNCDEC(X, N) truncates the elements of X to N decimals.
%
%   For instance, truncdec(10*sqrt(2) + i*pi/10, 4) returns
%   14.1421 + 0.3141i
%
%   See also: FIX, FLOOR, CEIL, ROUND, FIXDIG, ROUNDDEC, ROUNDDIG.

%   Author:      Peter J. Acklam
%   Time-stamp:  2001-05-19 17:05:48 +0200
%   E-mail:      pjacklam@online.no
%   URL:         http://home.online.no/~pjacklam

   y = fixdec(varargin{:});
