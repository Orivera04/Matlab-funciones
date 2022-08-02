function s = uint16_to_hex(x)
%UINT16_TO_HEX Convert uint16 number to hexadecimal string.
%
%   UINT16_TO_HEX(X), where X is an array with N uint16 elements, returns an
%   N-by-4 character array (string) of hexadecimal numbers where each row in
%   the output represents an element in X.
%
%   The input does not have to be of class uint16, but the input will be casted
%   to class uint16 so values that can't be represented as uint16 will be
%   truncated.
%
%   For example,
%
%      uint16_to_hex([    0
%                         1
%                         2
%                     65534
%                     65535
%                     65536])
%
%   returns
%
%      ['0000'
%       '0001'
%       '0002'
%       'fffe'
%       'ffff'
%       'ffff']
%
%   See also FORMAT HEX.

%   Author:      Peter J. Acklam
%   Time-stamp:  2003-11-17 11:20:18 +0100
%   E-mail:      pjacklam@online.no
%   URL:         http://home.online.no/~pjacklam

   % check number of input arguments
   error(nargchk(1, 1, nargin));

   x = x(:);

   if ~isreal(x)
      error('Input must be real.');
   end

   x = uint16(x);
   s = sprintf('%.4x', double(x));
   s = reshape(s, [4, length(x)]).';
