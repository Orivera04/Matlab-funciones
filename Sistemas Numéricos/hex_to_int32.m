function p = hex_to_int32(h)
%HEX_TO_INT32 Convert hexadecimal string to int32 number.
%
%   HEX_TO_INT32(H) converts the hexadecimal string H and returns the
%   corresponding int32 numbers.  Each row in H, representing one output value,
%   must only contain characters in the set '0123456789abcdefABCDEF'.
%
%   For example
%
%      hex_to_int32(['80000000'
%                    '80000001'
%                    'fffffffe'
%                    'ffffffff'
%                    '00000000'
%                    '00000001'
%                    '7ffffffe'
%                    '7fffffff'])
%
%   returns
%
%
%      [-2147483648
%       -2147483647
%                -2
%                -1
%                 0
%                 1
%        2147483646
%        2147483647]

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
   if (hd ~= 2) | (hs(2) ~= 8)
      error('Input must be a 2D matrix with eight columns.');
   end

   if any(   ( (h(:) < '0') | ('9' < h(:)) ) ...
           & ( (h(:) < 'A') | ('F' < h(:)) ) ...
           & ( (h(:) < 'a') | ('f' < h(:)) ) );
      error('Invalid hexadecimal string.');
   end

   % Convert to the output data type.
   n = uint32(reshape(sscanf(h, '%1x'), hs));
   m = uint32(n(:,1));
   m = bitor(bitshift(m, 4), n(:,2));
   m = bitor(bitshift(m, 4), n(:,3));
   m = bitor(bitshift(m, 4), n(:,4));
   m = bitor(bitshift(m, 4), n(:,5));
   m = bitor(bitshift(m, 4), n(:,6));
   m = bitor(bitshift(m, 4), n(:,7));
   m = bitor(bitshift(m, 4), n(:,8));

   i = n(:,1) >= 8;
   p = int32(m);
   p(i) = double(m(i)) - 4294967296;
