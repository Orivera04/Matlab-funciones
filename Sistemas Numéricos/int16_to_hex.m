function s = int16_to_hex(x)
%INT16_TO_HEX Convert int16 number to hexadecimal string.
%
%   INT16_TO_HEX(X), where X is an array with N int16 values, returns an N-by-4
%   character array (string) of hexadecimal numbers where each row in the
%   output represents an element in X.
%
%   The input does not have to be of class int16, but the input will be casted
%   to class int16 so values that can't be represented as int16 will be
%   truncated.
%
%   For example,
%
%      int16_to_hex([-32768
%                    -32767
%                        -2
%                        -1
%                         0
%                         1
%                     32766
%                     32767])
%
%   returns
%
%      ['8000'
%       '8001'
%       'fffe'
%       'ffff'
%       '0000'
%       '0001'
%       '7ffe'
%       '7fff']
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

   x = int16(x);
   k = x < 0;
   x = double(x);
   x(k) = x(k) + 65536;
   s = sprintf('%.4x', x);
   s = reshape(s, [4, length(x)]).';
