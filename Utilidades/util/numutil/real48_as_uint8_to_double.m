function y = real48_as_uint8_to_double(x)
%REAL48_AS_UINT8_TO_DOUBLE Convert Borland 6 byte reals (Real48) to doubles.
%
%   REAL48_AS_UINT8_TO_DOUBLE(X), where X is an M-by-6 matrix of integer values
%   in the set {0,1,...,255} (uint8 values), returns an M-by-1 vector of
%   doubles.  Each row vector in X is converted into one double.
%
%   REAL48_AS_UINT8_TO_DOUBLE(X), where X is an N-by-6-by-M-by-... array
%   returns an N-by-1-by-M-by-... array of doubles, where each 1-by-6 sub-array
%   in X is converted to one double value.
%
%   Converting hex strings to Real48 values
%   ---------------------------------------
%
%      str = ['490fdaa22182'                 % pi as hex Real48 value
%             '2df85458a282'];               % exp(1) as hex Real48 value
%      u8 = sscanf(str', '%2x')';            % convert to uint8 values
%      x = real48_as_uint8_to_double(u8);    % convert to double values
%
%   Reading Real48 values from a file
%   ---------------------------------
%   To read N Real48 values from a file identifier FID and convert them to
%   doubles, one can use
%
%      u8 = fread(fid, [6, n], 'uint8').';   % read bytes into n-by-6 array
%      y = real48_as_uint8_to_double(u8);    % convert to double
%
%   Note: Bytes are assumed to be in "big-endian" byte order.  If the data is
%   in "little-endian" (or "VAX") byte order, reverse the byte order like this
%
%      u8 = fread(fid, [6, n], 'uint8').';   % read bytes into n-by-6 array
%      u8 = flipdim(u8, 2);                  % reverse byte order
%      y = real48_as_uint8_to_double(u8);    % convert to double
%
%   The Real48 format
%   -----------------
%   The real48 consists of 6 bytes or 48 bits with field sizes 1, 39 and 8 for
%   sign, fraction part, and biased exponent, respectively.  The sign bit is 0
%   for positive, 1 for negative.  The first bit of the floating part field is
%   assumed to be 1 and is not stored explicitly.  The exponent field is 129
%   plus the actual exponent.  Thus, if s, f, and e are the sign, floating
%   part, and biased exponent, respectively, the value represented is
%
%      s = 0:       (1 + f) * 2 ^ (e - 129)
%      s = 1:      -(1 + f) * 2 ^ (e - 129)
%
%   An exception is zero, which is represented by both f and e being zero.
%   There are no bit patterns representing non-finite values like +/-Inf or
%   NaN.
%
%     sign                      fraction                      exponent
%     |1|                          39                       |     8    |
%     +---------+----------+----------+----------+----------+----------+
%     |         |          |          |          |          |          |
%     +---------+----------+----------+----------+----------+----------+
%      47     40 39      32 31      24 23      16 15       8 7        0
%
%   Some approximate numerical values
%   ---------------------------------
%   The largest positive numbers that can be represented are
%
%      1.701411834603145e+038  (f = pow2(2^39-1, -39), e = 255)
%      1.701411834601598e+038  (f = pow2(2^39-2, -39), e = 255)
%      1.701411834600050e+038  (f = pow2(2^39-3, -39), e = 255)
%      ...
%
%   The numbers closest to one are
%
%      ...
%      1.000000000005457       (f = pow2(3, -39),          e = 129)
%      1.000000000003638       (f = pow2(2, -39),          e = 129)
%      1.000000000001819       (f = pow2(1, -39),          e = 129)
%      1                       (f = 0,                     e = 129)
%      0.9999999999990905      (f = pow2(pow2(39)-1, -39), e = 128)
%      0.9999999999981810      (f = pow2(pow2(39)-2, -39), e = 128)
%      0.9999999999972715      (f = pow2(pow2(39)-3, -39), e = 128)
%      ...
%
%   The smallest positive numbers that can be represented are
%
%      ...
%      5.877471754111438e-039  (f = 3, e = 0)
%      4.408103815583578e-039  (f = 2, e = 0)
%      2.938735877055719e-039  (f = 1, e = 0)
%
%   The largest positive integer N for which all positive integers M <= N
%   can be represented exactly is
%
%       1099511627776 = 2^40   (f = 1, e = 169)
%
%   All Real48 values can be represented exactly as IEEE double precision
%   values, but the converse is not true.
%
%   See also HEX2NUM.

%   This program is based on a file "rpascal.m" written by Kelley Mascher
%   <mascher@u.washington.edu>.

%   Author:      Peter J. Acklam
%   Time-stamp:  2003-11-17 19:34:47 +0100
%   E-mail:      pjacklam@online.no
%   URL:         http://home.online.no/~pjacklam

   % Check number of input arguments.
   error(nargchk(1, 1, nargin));

   % Make sure the input is real.
   if ~isreal(x)
      error('Input must be real.');
   end

   % Check the input values.
   if any((x(:) < 0) | (255 < x(:)))
      error('Input values must be in {0,1,2,...,255}.');
   end

   % Make sure input is uint8 since not all classes support bit-operations.
   x = uint8(x);

   % See if the input array has the right number of columns.
   sx = size(x);
   if mod(sx(2), 6)
      error('The number of columns must be a multiple of six.');
   end

   % Compute the size of the output array.
   sy = sx;
   sy(2) = sy(2) / 6;

   % Extract the sign.
   s = logical(bitget(x(:,1:6:end,:), 8));

   % Extract the fraction part.
   f = ((((   double(x(:,5:6:end,:))  / 256 ...
            + double(x(:,4:6:end,:))) / 256 ...
            + double(x(:,3:6:end,:))) / 256 ...
            + double(x(:,2:6:end,:))) / 256 ...
            + double(bitand(x(:,1:6:end,:), 127))) / 128;

   % Extract the exponent.
   e = double(x(:,6:6:end,:));

   % Compute floating point value.
   y = pow2(1 + f, e - 129);

   % Zeros are a special case.
   y(f == 0 & e == 0) = 0;

   % Fix the sign.
   y(s) = -y(s);

   % Reshape the output to the correct size.
   y = reshape(y, sy);
