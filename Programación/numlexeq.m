function tf = numlexeq(a, b)
%NUMLEXEQ Lexicographic equal to.
%
%   NUMLEXEQ(A, B) returns 1 if A is lexicographically equal to B, and 0
%   otherwise.
%
%   See also EQ.

%   Author:      Peter J. Acklam
%   Time-stamp:  2003-11-08 21:09:19 +0100
%   E-mail:      pjacklam@online.no
%   URL:         http://home.online.no/~pjacklam

   % check number of input arguments
   error(nargchk(2, 2, nargin));

   %tf = numlexcmp(a, b) == 0;
   tf = a == b;
