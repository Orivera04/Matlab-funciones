function r = quadroot(p)
%QUADROOT Return roots of a quadratic polynomial.
%
%   QUADROOT(P), where P = [A B C], solves the quadratic equation
%
%      A*X^2 + B*X + C  =  0.
%
%   QUADROOTS is occasionally more accurate than ROOTS.  An example of this is
%   the ill-conditioned case when P = [1 3e16 1].
%
%   See also ROOTS.

%   Author:      Peter J. Acklam
%   Time-stamp:  2004-02-03 22:41:46 +0100
%   E-mail:      pjacklam@online.no
%   URL:         http://home.online.no/~pjacklam

   % Check number of input arguments.
   error(nargchk(1, 1, nargin));

   % Check array class.
   if ~isnumeric(p)
      error('P must be a numeric array.');
   end

   % Check array size.
   if (ndims(p) ~= 2) | (size(p, 1) ~= 1)
      error('P must be row vector.');
   end

   a = p(1);
   b = p(2);
   c = p(3);

   if a == 0
      if b == 0
         if c == 0
            %
            % a, b, c are zero: 0 = 0
            %
            error('All coefficients are zero');
         else
            %
            % a, b are zero: c = 0;
            %
            error('Constant equation');
         end
      else
         if c == 0
            %
            % a, c are zero: b*x = 0
            %
            r = 0;
            return;
         else
            %
            % a is zero: b*x + c = 0
            %
            r = -c/b;
            return;
         end
      end
   else
      if b == 0
         if c == 0
            %
            % b, c are zero: a*x^2 = 0
            %
            r = [0 0];
            return;
         else
            %
            % b is zero: a*x^2 + c = 0
            %
            t = sqrt(c/a);
            r = [t -t];
            return;
         end
      else
         if c == 0
            %
            % c is zero: a*x^2 + b*x = 0;
            %
            r = [0 -b/a];
            return;
         else
            %
            % none of a, b, c are zero: a*x^2 + b*x + c = 0
            %
            d = b*b - 4*a*c;    % discriminant
            if d == 0
               % two identical roots
               t = -b/(2*a);
               r = [t t];
               return;
            else
               if sign(real(sqrt(d))) == sign(real(b))
                  t = -b - sqrt(d);
               else
                  t = -b + sqrt(d);
               end
               r = [ t/(2*a) (2*c)/t ];
               return;
            end
         end
      end
   end

   % we should never get here
   error('Internal error');
