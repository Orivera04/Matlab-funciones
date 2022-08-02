function r = polyreloc(p, x, y)
%POLYRELOC Relocate polynomial.
%
%   R = POLYRELOC(P, X, Y) relocates the polynomial by "moving" it X units
%   along the x-axis and Y units along the y-axis. So R is relative to the
%   point (X,Y) as P is relative to the point (0,0).
%
%   P is a vector of coefficients in decreasing order.
%
%   See also POLYRESCL.

%   Author:      Peter J. Acklam
%   Time-stamp:  2004-02-03 22:34:43 +0100
%   E-mail:      pjacklam@online.no
%   URL:         http://home.online.no/~pjacklam

   % Check number of input arguments.
   nargsin = nargin;
   error(nargchk(2, 3, nargsin));

   %
   % Check first argument.
   %

   % Check array class.
   if ~isnumeric(p)
      error('P must be a numeric array.');
   end

   % Check array size.
   if (ndims(p) ~= 2) | (size(p, 1) ~= 1)
      error('P must be row vector.');
   end

   %
   % Check second argument.
   %

   % Check array class.
   if ~isnumeric(x)
      error('X must be a numeric array.');
   end

   % Check array size.
   if any(size(x) ~= 1)
      error('X must be scalar.');
   end

   %
   % Move polynomial X units to the right by a polynomial version of Horner's
   % method.
   %

   f = [ 1 -x ];
   n = length(p);
   r = p(1);
   for i = 1 : n-1
      r = conv(r, f);
      r(i+1) = r(i+1) + p(i+1);
   end

   %
   % Move polynomial Y units upwards by adding Y.
   %

   if nargsin > 2

      %
      % Check third argument.
      %

      % Check array class.
      if ~isnumeric(y)
         error('Y must be a numeric array.');
      end

      % Check array size.
      if any(size(y) ~= 1)
         error('Y must be scalar.');
      end

      r(n) = r(n) + y;
      
   end
