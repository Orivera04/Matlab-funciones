function y = truncdig(varargin)
%TRUNCDIG Truncate to a specified number of digits.
%
%   Y = TRUNCDIG(X, N) truncates the elements of X to N digits.
%
%   For instance, truncdig(10*sqrt(2) + i*pi/10, 4) returns 14.14 + 0.3141i
%
%   See also: FIX, FLOOR, CEIL, ROUND, FIXDEC, ROUNDDIG, ROUNDDEC.

%   Author:      Peter J. Acklam
%   Time-stamp:  2001-05-19 17:05:48 +0200
%   E-mail:      pjacklam@online.no
%   URL:         http://home.online.no/~pjacklam

   y = fixdig(varargin{:});
