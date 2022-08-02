function tf = numlexcmp(a, b)
%NUMLEXCMP Lexicographic comparison of two numbers.
%
%   NUMLEXCMP(A, B) returns -1, 0, or 1 depending on whether the left argument
%   is lexicographically less than, equal to, or greater than the right
%   argument.
%
%   When A or B is complex, the real parts of the elements are compared, and if
%   the real parts are identical, the imaginary parts are compared.
%
%   This is a MATLAB version of the Perl `<=>' operator.

%   Author:      Peter J. Acklam
%   Time-stamp:  2003-11-08 21:09:19 +0100
%   E-mail:      pjacklam@online.no
%   URL:         http://home.online.no/~pjacklam

   % check number of input arguments
   error(nargchk(2, 2, nargin));

   % check input arguments
   if ~isnumeric(a) | ~isnumeric(b)
      error('Both arguments must be numerical arrays.');
   end

   % Comparison is done with (x < y) - (x > y).  We could have used sign(x - y),
   % but both `-' and `sign' are, by default, only defined for numerical arrays
   % of class double.

   % compare real parts
   tf = (real(a) < real(b)) - (real(a) > real(b));

   % compare imaginary parts if necessary
   if ~isreal(a) | ~isreal(b)
      k = ~tf;
      if any(k(:))
         tf(k) = (imag(a(k)) < imag(b(k))) - (imag(a(k)) > imag(b(k)));
      end
   end
