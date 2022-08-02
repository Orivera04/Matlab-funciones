function s = uint64_to_hex(x)
%UINT64_TO_HEX Convert uint64 number to hexadecimal string.
%
%   UINT64_TO_HEX(X), where X is an array with N uint64 values, returns an
%   N-by-16 character array (string) of hexadecimal numbers where each row in
%   the output represents an element in X.
%
%   The input does not have to be of class uint64, but the input will be casted
%   to class uint64 so values that can't be represented as uint64 will be
%   truncated.
%
%   For example,
%
%      x = 2^32 - 1;
%      uint64_to_hex([                                 0
%                                                      1
%                                                      2
%                     bitor(bitshift(uint64(x), 32), x-2)
%                     bitor(bitshift(uint64(x), 32), x-1)
%                     bitor(bitshift(uint64(x), 32), x  )])
%
%   returns
%
%      ['0000000000000000'
%       '0000000000000001'
%       '0000000000000002'
%       'fffffffffffffffd'
%       'fffffffffffffffe'
%       'ffffffffffffffff']
%
%   Note that MATLAB's default input method only allows you to enter double
%   precision numbers.  The only uint64 values that can be represented exactly
%   with double precision are the numbers in the range 0 <= x <= 2^53 =
%   9007199254740992 which is less than the full uint64 range 0 <= x <= 2^64-1
%   = 18446744073709551615.  Uint64 values can most easily be created by
%   assembling the higher and lower 32 bits into a 64 bit number.  Here is an
%   example showing how to create the largest possible uint64 value:
%
%       hi32 = 2^32 - 1;
%       lo32 = 2^32 - 1.
%       u64 = bitor(bitshift(uint64(hi32), 32), lo32);
%
%   See also FORMAT HEX.

%   Author:      Peter J. Acklam
%   Time-stamp:  2003-11-17 11:21:25 +0100
%   E-mail:      pjacklam@online.no
%   URL:         http://home.online.no/~pjacklam

   % check number of input arguments
   error(nargchk(1, 1, nargin));

   x = x(:);

   if ~isreal(x)
      error('Input must be real.');
   end

   x = uint64(x);

   hi = bitshift(x, -32);               % highest 32 bits
   lo = bitand(x, 4294967295);          % loweest 32 bits

   hi = double(hi);
   lo = double(lo);

   s = sprintf('%.8x', [hi, lo]');
   s = reshape(s, [16, length(x)]).';
