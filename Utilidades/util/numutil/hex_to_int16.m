function p = hex_to_int16(h)
%HEX_TO_INT16 Convert hexadecimal string to int16 number.
%
%   HEX_TO_INT16(H) converts the hexadecimal string H and returns the
%   corresponding int16 numbers.  Each row in H, representing one output value,
%   must only contain characters in the set '0123456789abcdefABCDEF'.
%
%   For example
%
%      hex_to_int16(['8000'
%                    '8001'
%                    'fffe'
%                    'ffff'
%                    '0000'
%                    '0001'
%                    '7ffe'
%                    '7fff'])
%
%   returns
%
%      [-32768
%       -32767
%           -2
%           -1
%            0
%            1
%        32766
%        32767]

%   Author:      Peter J. Acklam
%   Time-stamp:  2003-11-08 15:06:11 +0100
%   E-mail:      pjacklam@online.no
%   URL:         http://home.online.no/~pjacklam

   % Check number of input arguments.
   error(nargchk(1, 1, nargin));

   % Check type and size of input argument.
   if ~ischar(h)
      error('Argument must be a character array.');
   end

   hs = size(h);
   hd = ndims(h);
   if (hd ~= 2) | (hs(2) ~= 4)
      error('Input must be a 2D matrix with four columns.');
   end

   if any(   ( (h(:) < '0') | ('9' < h(:)) ) ...
           & ( (h(:) < 'A') | ('F' < h(:)) ) ...
           & ( (h(:) < 'a') | ('f' < h(:)) ) );
      error('Invalid hexadecimal string.');
   end

   % Convert to the output data type.
   n = uint16(reshape(sscanf(h, '%1x'), hs));
   m = uint16(n(:,1));
   m = bitor(bitshift(m, 4), n(:,2));
   m = bitor(bitshift(m, 4), n(:,3));
   m = bitor(bitshift(m, 4), n(:,4));

   i = n(:,1) >= 8;
   p = int16(m);
   p(i) = double(m(i)) - 65536;
