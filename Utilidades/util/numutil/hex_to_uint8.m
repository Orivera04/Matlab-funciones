function m = hex_to_uint8(h)
%HEX_TO_UINT8 Convert hexadecimal string to uint8 number.
%
%   HEX_TO_UINT8(H) converts the hexadecimal string H and returns the
%   corresponding uint8 numbers.  Each row in H, representing one output value,
%   must only contain characters in the set '0123456789abcdefABCDEF'.
%
%   For example
%
%      hex_to_uint8(['00'
%                    '01'
%                    '02'
%                    'fd'
%                    'fe'
%                    'ff'])
%
%   returns
%
%      [   0
%          1
%          2
%        253
%        254
%        255]

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
   if hd > 2 | hs(2) ~= 2
      error('Input must be a 2D matrix with two columns.');
   end

   if any(   ( ( h(:) < '0' ) | ( '9' < h(:) ) ) ...
           & ( ( h(:) < 'A' ) | ( 'F' < h(:) ) ) ...
           & ( ( h(:) < 'a' ) | ( 'f' < h(:) ) ) );
      error('Invalid hexadecimal string.');
   end

   % Convert to the output data type.
   n = uint8(reshape(sscanf(h, '%1x'), hs));
   m = uint8(n(:,1));
   m = bitor(bitshift(m, 4), n(:,2));
