function t = isvarmat(S)
%ISVARMAT True for variance matrix input.
%
%   ISVARMAT(S) returns 1 if S is a valid variance matrix and 0 otherwise.
%
%   See also VARCHK.

%   Author:      Peter J. Acklam
%   Time-stamp:  2001-06-19 12:40:31 +0200
%   E-mail:      pjacklam@online.no
%   URL:         http://home.online.no/~pjacklam

   error(nargchk(1, 1, nargin));

   t = isempty(varchk(S));
