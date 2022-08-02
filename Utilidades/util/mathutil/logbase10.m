function y = logbase10(x)
%LOGBASE10  Common (base 10) logarithm.
%
%   LOGBASE10(X) is the base 10 logarithm of the elements of X.
%   LOGBASE10 is the same as LOG10 except that the former returns a more
%   accurate result.  For instance, LOG10(1000) does not return exactly 3,
%   whereas LOGBASE10 does.
%
%   See also LOG10, LOG, LOG2, EXP.

%   Author:      Peter J. Acklam
%   Time-stamp:  2003-10-13 14:58:24 +0200
%   E-mail:      pjacklam@online.no
%   URL:         http://home.online.no/~pjacklam

   % check number of input arguments
   error(nargchk(1, 1, nargin));

   log_of_ten = log(10);

   y = log(x) ./ log_of_ten;                    % predictor
   y = y - log(10.^y ./ x) ./ log_of_ten;       % corrector
