function q = unwrapdeg(varargin)
%UNWRAPDEG Unwrap phase angle in degrees.
%
%   UNWRAPDEG does the same as UNWRAP except input and output is in degrees
%   rather than radians.
%
%   See also UNWRAP, UNWRAPGRAD.

%   Author:      Peter J. Acklam
%   Time-stamp:  2004-02-19 17:14:32 +0100
%   E-mail:      pjacklam@online.no
%   URL:         http://home.online.no/~pjacklam

   % check number of input arguments
   error(nargchk(1, 3, nargin));

   % check array class
   if ~isnumeric(varargin{1})
      error('Input must be a numeric array.');
   end

   % degrees to radians and vice versa
   d2r = pi / 180;
   r2d = 180 / pi;

   % convert from degrees to radians
   for i = 1 : min(nargin, 2)
      varargin{i} = d2r * varargin{i};
   end

   q = r2d * unwrap(varargin{:});
