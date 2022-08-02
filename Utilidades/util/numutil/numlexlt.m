function tf = numlexlt(a, b)
%NUMLEXLT Lexicographic less than.
%
%   NUMLEXLT(A, B) returns 1 if A is lexicographically less than B, and 0
%   otherwise.
%
%   See also LT.

%   Author:      Peter J. Acklam
%   Time-stamp:  2003-11-08 21:09:19 +0100
%   E-mail:      pjacklam@online.no
%   URL:         http://home.online.no/~pjacklam

   % check number of input arguments
   error(nargchk(2, 2, nargin));

   tf = numlexcmp(a, b) < 0;
