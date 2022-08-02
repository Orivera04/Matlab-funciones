function b = wrapdeg(a)
%WRAPDEG Map angles measured in degrees to the interval [-180,180).
%
%   B = WRAPDEG(A) maps the angles in A to their equivalent in the interval
%   [-180,180) by adding or subtracting the appropriate multiple of 360.
%
%   See also WRAPRAD, WRAPGRAD, UNWRAP.

%   Author:      Peter J. Acklam
%   Time-stamp:  2004-02-19 12:42:49 +0100
%   E-mail:      pjacklam@online.no
%   URL:         http://home.online.no/~pjacklam

   % check number of input arguments
   error(nargchk(1, 1, nargin));

   % check array class
   if ~isnumeric(a)
      error('Input must be a numeric array.');
   end

   b = a - 360 * floor((a + 180) / 360);
