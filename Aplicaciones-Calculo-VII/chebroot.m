function x = chebroot(n)
%CHEBROOT Roots of Chebychev polynomial of the first kind.
%
%   X = CHEBROOT(N) returns the roots of the Chebychev polynomial of the first
%   kind of degree N.
%
%   Because the extreme values of Chebychev polynomials of the first kind are
%   either -1 or 1, their roots are often used as starting values for the nodes
%   in mimimax approximations.
%
%   See also CHEBPOLY, CHEBEXTR.

%   Author:      Peter J. Acklam
%   Time-stamp:  2004-02-02 08:27:12 +0100
%   E-mail:      pjacklam@online.no
%   URL:         http://home.online.no/~pjacklam

   error(nargchk(1, 1, nargin));

   if ~isa(n, 'double') | any(size(n) ~= 1) | ~isreal(n)
      error('N must be double, scalar, and real.');
   end
   if (n < 1) | (n ~= round(n))
      error('N must be a positive integer');
   end

   x = cos(pi / n * (n-0.5 : -1 : 0.5));

   % adjust for the fact that cos(pi / 2) is not exactly zero
   if rem(n, 2)
      x((n+1) / 2) = 0;
   end

   % this is faster if `n' is very large
   % x = zeros(1, n);
   % if rem(n, 2)
   %    t = cos(pi / n * (0.5 : n/2-1));
   %    x( 1 :      (n-1)/2 ) = -t;
   %    x( n : -1 : (n+3)/2 ) =  t;
   % else
   %    t = cos(pi / n * (0.5 : n/2-0.5));
   %    x( 1 :      n/2   ) = -t;
   %    x( n : -1 : n/2+1 ) =  t;
   % end
