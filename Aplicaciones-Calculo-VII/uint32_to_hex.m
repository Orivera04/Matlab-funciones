function s = uint32_to_hex(x)
%UINT32_TO_HEX Convert uint32 number to hexadecimal string.
%
%   UINT32_TO_HEX(X), where X is an array with N uint32 values, returns an
%   N-by-8 character array (string) of hexadecimal numbers where each row in
%   the output represents an element in X.
%
%   The input does not have to be of class uint32, but the input will be casted
%   to class uint32 so values that can't be represented as uint32 will be
%   truncated.
%
%   For example,
%
%      uint32_to_hex([         0
%                              1
%                              2
%                     4294967294
%                     4294967295
%                     4294967296])
%
%   returns
%
%      ['00000000'
%       '00000001'
%       '00000002'
%       'fffffffe'
%       'ffffffff'
%       'ffffffff']
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

   x = uint32(x);
   s = sprintf('%.8x', double(x));
   s = reshape(s, [8, length(x)]).';
