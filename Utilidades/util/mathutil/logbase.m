function y = logbase(x, base)
%LOGBASE Logarithm with respect to specified base.
%
%   LOGBASE(X, BASE) is the logarithm of the elements of X with respect to the
%   base BASE.  If BASE is omitted, the natural (base e) logarithm is returned.
%
%   LOGBASE(X, [EXP(1) 10 2]) returns the natural logarithm, the base 10
%   logarithm and the base 2 logarithm of X.
%
%   See also LOG10, LOG, LOG2, EXP.

%   Author:      Peter J. Acklam
%   Time-stamp:  2003-10-13 14:58:07 +0200
%   E-mail:      pjacklam@online.no
%   URL:         http://home.online.no/~pjacklam

   % check number of input arguments
   error(nargchk(1, 2, nargin));

   if nargin < 2
      y = log(x);
      return
   end

   log_of_base = log(base);

   y = log(x) ./ log_of_base;                   % prediction
   y = y - log(base.^y ./ x) ./ log_of_base;    % correction
