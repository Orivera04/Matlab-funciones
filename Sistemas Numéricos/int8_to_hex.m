function s = int8_to_hex(x)
%INT8_TO_HEX Convert int8 number to hexadecimal string.
%
%   INT8_TO_HEX(X), where X is an array with N int8 values, returns an N-by-2
%   character array (string) of hexadecimal numbers where each row in the
%   output represents an element in X.
%
%   The input does not have to be of class int8, but the input will be casted
%   to class int8 so values that can't be represented as int8 will be
%   truncated.
%
%   For example,
%
%      int8_to_hex([-128
%                   -127
%                     -2
%                     -1
%                      0
%                      1
%                    126
%                    127])
%
%   returns
%
%      ['80'
%       '81'
%       'fe'
%       'ff'
%       '00'
%       '01'
%       '7e'
%       '7f']
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

   x = int8(x);
   k = x < 0;
   x = double(x);
   x(k) = x(k) + 256;
   s = sprintf('%.2x', x);
   s = reshape(s, [2, length(x)]).';
