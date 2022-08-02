function [fr, er, fi, ei] = unpacknum(x, base, n)
%UNPACKNUM Unpack number into fraction and exponent.
%
%   [F, E] = UNPACKNUM(X, BASE) unpacks the real number X so that X = F *
%   BASE^E, where 1 <= |F| < BASE and E is an integer.  BASE must be larger
%   than one.
%
%   [FR, ER, FI, EI] = UNPACKNUM(X, BASE) unpacks the complex number X so that
%   X = FR * BASE^ER + i * FI * BASE^EI.
%
%   [...] = UNPACKNUM(X, BASE, N) will make sure BASE is a multiple of N.  N
%   must be a positive value.  In this case, 1 <= |F| < BASE*N.
%
%   Example:  To display a number using "engineering notation", where the power
%   of ten is always a multiple of three, use BASE = 10 and N = 3:
%
%      x = 8.560372e-25;
%      [f, e] = unpacknum(x, 10, 3);      % f = 856.0372 and e = -27
%      fprintf('%.15ge%+.03d\n', f, e);   % displays `856.0372e-027'
%
%   See also LOG2.

%   Author:      Peter J. Acklam
%   Time-stamp:  2003-11-04 11:10:00 +0100
%   E-mail:      pjacklam@online.no
%   URL:         http://home.online.no/~pjacklam

   % check number of input arguments
   nargsin = nargin;
   error(nargchk(2, 3, nargsin));

   x = double(x);

   % check the `base' argument
   if ~isnumeric(base) | ~isreal(base) | any(base <= 1)
      error('BASE must contain only real values > 1.');
   end
   base = double(base);

   if nargin < 3
      n = 1;
   else
      % check the `n' argument
      if ~isnumeric(n) | ~isreal(n) | any(n <= 0)
         error('N must contain only real positive values.');
      end
      n = double(n);
   end

   % do the real part of `x'
   [fr, er] = unpack(real(x), base, n);

   % only do the imaginary part of `x' if necessary
   if nargout > 2
      if any(imag(x(:)))
         [fi, ei] = unpack(imag(x), base, n);
      else
         fi = zeros(size(fr));
         ei = fi;
      end
   end

function [f, e] = unpack(x, base, n)
%UNPACK Unpack real number into fraction and exponent.

   % We could treat `base = 2' as a special case and use `log2', but that
   % would require more work than I think it's worth -- especially when
   % `base' is not a scalar.

   ax = abs(x);
   ax(~ax) = 1;                         % avoid log(0) error
   e = floor(log(ax) ./ log(base));     % prediction
   e = e  + ( ax == base.^(e+1) );      % correction
   e = n .* floor(e ./ n);              % make `e' a multiple of `n'
   f = x ./ base.^e;                    % compute `f'
