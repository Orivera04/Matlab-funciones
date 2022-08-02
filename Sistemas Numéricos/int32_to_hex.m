function s = int32_to_hex(x)
%INT32_TO_HEX Convert int32 number to hexadecimal string.
%
%   INT32_TO_HEX(X), where X is an array with N int32 values, returns an N-by-8
%   character array (string) of hexadecimal numbers where each row in the
%   output represents an element in X.
%
%   The input does not have to be of class int32, but the input will be casted
%   to class int32 so values that can't be represented as int32 will be
%   truncated.
%
%   For example,
%
%      int32_to_hex([-2147483648
%                    -2147483647
%                             -2
%                             -1
%                              0
%                              1
%                     2147483646
%                     2147483647])
%
%   returns
%
%      ['80000000'
%       '80000001'
%       'fffffffe'
%       'ffffffff'
%       '00000000'
%       '00000001'
%       '7ffffffe'
%       '7fffffff']
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

   x = int32(x);
   k = x < 0;
   x = double(x);
   x(k) = x(k) + 4294967296;
   s = sprintf('%.8x', x);
   s = reshape(s, [8, length(x)]).';
