function q = polyrescl(p, x, y)
%POLYRESCL Rescale polynomial.
%
%   Q = POLYRESCL(P, X, Y) rescaled the polynomial P by a factor X in
%   x-direction and by a factor Y in y-direction.
%
%   P is a vector of coefficients in decreasing order.
%
%   See also POLYRELOC.

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

   % Now do the job.
   if nargsin > 1
      n = length(p);
      q = p .* x.^(1-n : 0);
   end

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

      q = y .* q;

   end
