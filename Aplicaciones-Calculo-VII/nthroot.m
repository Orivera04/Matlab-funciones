function y = nthroot(x, n)
%NTHROOT Compute the n-th root of a real number.
%
%   NTHROOT(X, N) returns the Nth root of the elements of X.  X and N must be
%   real, and when X is negative, N must be an odd integer.
%
%   See also POWER.

%   Author:      Peter J. Acklam
%   Time-stamp:  2004-02-08 13:07:10 +0100
%   E-mail:      pjacklam@online.no
%   URL:         http://home.online.no/~pjacklam

   %
   % Check number of input arguments.
   %

   error(nargchk(2, 2, nargin));

   %
   % Check array size consistency.
   %
   % Get the size of the input arrays.  Delay replication (scalar expansion) of
   % input arguments until after we have checked the array values, but remember
   % which variables that must be replicated.  Also get size of output array.
   %

   sx = size(x);
   sn = size(n);

   do_rep_x = false;            % should X be replicated?
   do_rep_n = false;            % should X be replicated?

   if any(sx ~= 1)
      if any(sn ~= 1)
         % X and N are both non-scalar
         if ~isequal(sx, sn)
            error(['When X and N both are non-scalars, ' ...
                   'they must have the same size.']);
         end
      else
         % X is non-scalar, N is scalar, so replicate N
         do_rep_n = true;
      end
      sy = sx;
   else
      if any(sn ~= 1)
         % X is scalar, N is non-scalar, so remember to replicate X
         do_rep_x = true;
      else
         % X and N are both scalar
      end
      sy = sn;
   end

   %
   % Check array values.
   %

   if ~isreal(x) | ~isreal(n)
      error('Both X and N must be real.');
   end

   if any((x(:) < 0) & mod(n(:), 2) ~= 1) & (x(:) ~= 0)
      error('When X is negative, N must be an odd integer or zero.');
   end

   %
   % Replicate variable if required.
   %

   if do_rep_x
      x = repmat(x, sy);
   elseif do_rep_x
      n = repmat(n, sy);
   end

   % Initialize output.
   y = repmat(NaN, sy);

   %
   % Step 1
   %
   % Depending on which way N converges to zero, the expression X^(1/N) converges
   % to different values, so output must be NaN whenever N is zero.  The output
   % is also NaN whenever N or X is NaN.
   
   k = (n ~= 0) & ~isnan(n) & ~isnan(x);
   y(k) = sign(x(k)) .* abs(x(k)).^(1 ./ n(k));

   % Step 2
   
   % Correct numerical errors (since, e.g., 64^(1/3) is not exactly 4) by one
   % iteration of Newton's method.

   % Skip NaNs and +/-Infs in Y and X.  Also skip the case when Y = 0; it would
   % cause a divide by zero warning.
   k = isfinite(y) & isfinite(n) & (y ~= 0);
   y(k) = y(k) - (y(k).^n(k) - x(k)) ./ (n(k) .* y(k).^(n(k) - 1));
