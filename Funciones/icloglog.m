function x = icloglog(y)
%ICLOGLOG The inverse complementary log log transformation.
%
%   The inverse tranformation maps the whole real line to the interval (0,1).
%   The tranformation is X = 1 - EXP(-EXP(Y)).
%
%   See also CLOGLOG.

%   Author:      Peter J. Acklam
%   Time-stamp:  2003-11-04 10:45:38 +0100
%   E-mail:      pjacklam@online.no
%   URL:         http://home.online.no/~pjacklam

   error(nargchk(1, 1, nargin));

   x = 1 - exp(-exp(y));
