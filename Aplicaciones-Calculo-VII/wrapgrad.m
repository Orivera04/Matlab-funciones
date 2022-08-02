function b = wrapgrad(a)
%WRAPGRAD Map angles measured in gradians to the interval [-200,200).
%
%   B = WRAPGRAD(A) maps the angles in A to their equivalent in the interval
%   [-200,200) by adding or subtracting the appropriate multiple of 400.
%
%   See also WRAPRAD, WRAPDEG, UNWRAP.

%   Author:      Peter J. Acklam
%   Time-stamp:  2004-02-19 12:42:51 +0100
%   E-mail:      pjacklam@online.no
%   URL:         http://home.online.no/~pjacklam

   % check number of input arguments
   error(nargchk(1, 1, nargin));

   % check array class
   if ~isnumeric(a)
      error('Input must be a numeric array.');
   end

   b = a - 400 * floor((a + 200) / 400);
