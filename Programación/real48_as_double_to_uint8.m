function [u8, ok] = real48_as_double_to_uint8(x)
%REAL48_AS_DOUBLE_TO_UINT8 Convert doubles to Borland 6 byte reals (Real48).
%
%   U8 = REAL48_AS_DOUBLE_TO_UINT8(X) converts each value in X into six uint8
%   values which are the bytes required to represent the value.  If X is an
%   N-by-M-by-P-by-... array, the output will be a N-by-6*M-by-P-by-... array
%   where each 1-by-6 sub-array represents a value in X.
%
%   [U8, OK] = REAL48_AS_DOUBLE_TO_UINT8(X) returns a logical array OK with the
%   same size as X which contains ones for all values of X what could be
%   converted exactly and zeros for all other values.
%
%   See also REAL48_AS_UINT8_TO_DOUBLE.

%   Author:      Peter J. Acklam
%   Time-stamp:  2003-11-17 19:34:50 +0100
%   E-mail:      pjacklam@online.no
%   URL:         http://home.online.no/~pjacklam

   % Check number of input arguments.
   error(nargchk(1, 1, nargin));

   % Make sure the input is real.
   if ~isreal(x)
      error('Input must be real.');
   end

   % Make sure the input is double since we'll be doing some arithmetic.
   x = double(x);

   % The largest and smallest positive numbers that can be represented.
   %realmax = pow2(1 + pow2(2^39-1, -39), 126);  % 1.701411834603145e+038
   %realmax = pow2(2 - pow2(1, -39), 126);       % 1.701411834603145e+038
   %realmin = pow2(-126);                        % 2.938735877055719e-039

   % Get the size of x, the number of dimensions, and the number of elements.
   sx = size(x);
   dx = ndims(x);
   nx = numel(x);

   % Collaps dimensions 3, 4, ... to make the input 3-dimensional.  Then
   % initialize the output.
   m = prod(sx(3:end));
   x  = reshape(       x, [sx(1),   sx(2), m]);
   u8 = repmat (uint8(0), [sx(1), 6*sx(2), m]);

   % Get the sign bit and split the numbers into fraction and exponent.
   s = uint8(x < 0);
   [f, e] = log2(abs(x));

   % Adjust "f" and "e" so that x = (1 + f) * 2^(e - 129).
   f = 2 * f - 1;
   e = e + 128;

   % Zero is represented by both "e" and "f" being zero.
   e(x == 0) = 0;

   % Insert the sign bit.  This is the highest bit in the first byte.
   u8(:,1:6:end,:) = bitshift(s, 7);

   % Insert the highest seven bits of the fraction into the lowest seven bits of
   % the first byte.
   f = pow2(f, 7);
   intf = fix(f);
   u8(:,1:6:end,:) = bitor(u8(:,1:6:end,:), uint8(intf));
   f = f - intf;

   % Place the 32 lowest bits of the fraction into the middle four bytes.
   for i = 2 : 5
      f = pow2(f, 8);
      intf = fix(f);
      u8(:,i:6:end,:) = bitor(u8(:,i:6:end,:), uint8(intf));
      f = f - intf;
   end

   % The last byte contains the exponent.
   u8(:,6:6:end,:) = e;

   % Expand the dimensions that we collapsed earlier.
   u8 = reshape(u8, [sx(1), 6*sx(2), sx(3:end)]);

   % Create the OK array only if it is wanted.
   if nargout > 1
      ok = (f == 0) & (0 <= e) & (e <= 255) & isfinite(x);
   end
