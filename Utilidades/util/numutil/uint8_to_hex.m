function s = uint8_to_hex(x)
%UINT8_TO_HEX Convert uint8 number to hexadecimal string.
%
%   INT8_TO_HEX(X), where X is an array with N int8 values, returns an N-by-2
%   character array (string) of hexadecimal numbers where each row in the
%   output represents an element in X.
%
%   The input does not have to be of class uint8, but the input will be casted
%   to class uint8 so values that can't be represented as uint8 will be
%   truncated.
%
%   For example,
%
%      uint8_to_hex([  0
%                      1
%                      2
%                    254
%                    255
%                    256])
%
%   returns
%
%
%      ['00'
%       '01'
%       '02'
%       'fe'
%       'ff'
%       'ff']
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

   x = uint8(x);
   s = sprintf('%.2x', double(x));
   s = reshape(s, [2, length(x)]).';
