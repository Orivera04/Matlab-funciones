function c = lcmall(x)
%LCMALL Least common multiple of all elements.
%
%   LCMALL(X) is the least common multiple of all elements in X.
%
%   See also GCD, LCM, GCDALL.

%   Author:      Peter J. Acklam
%   Time-stamp:  2002-03-03 13:51:44 +0100
%   E-mail:      pjacklam@online.no
%   URL:         http://home.online.no/~pjacklam

   % Check input arguments.
   error(nargchk(1, 1, nargin));

   if ~isnumeric(x) | ~isreal(x)
      error( 'Argument must be numeric and real.' );
   end

   if ~isequal( round(x), x )
      error( 'Argument must contain integers only.' );
   end

   % Now find least common multiple.
   n = prod( size(x) );
   c = x(1);
   for i = 1:n
      if ( x(i) ~= 0 )
         c = c/gcd(c,x(i))*x(i);
      end
   end
