function y = nybble2byte(x)
%NYBBLE2BYTE Convert nybbles to bytes.
%
%   NYBBLE2BYTE(X), where X is a row vector of base 16 integers returns a
%   vector half the length of the input vector, where each successive pair of
%   elements has been merged into a single byte.  The base 16 integers may be
%   given either as integers in the set 0,1,...,15, or characters in the set
%   '0123456789abcdef'.  Upper-case characters are also allowed.
%
%   If X is an array, the same operation is performed on each row
%   X(I,:,J,K,...).
%
%   Examples:
%
%     nybble2byte([ 0 0 15 15 7 15 0 4 ]) returns [ 0 255 127 4 ].
%     nybble2byte('00ff7f04') returns [ 0 255 127 4 ].
%
%   See also BYTE2NYBBLE.

%   Author:      Peter J. Acklam
%   Time-stamp:  2004-02-05 18:24:31 +0100
%   E-mail:      pjacklam@online.no
%   URL:         http://home.online.no/~pjacklam

   % Check number of input arguments.
   error(nargchk(1, 1, nargin));

   % Check array class.
   if ~isnumeric(x) & ~ischar(x)
      error('Input must be a numeric array or character array.');
   end

   % Check array size.
   sx = size(x);
   if rem(sx(2), 2)
      error('Number of columns must be a multiple of two.');
   end

   % Compute the size of the output array.
   sy = sx;
   sy(2) = sy(2) / 2;

   % Convert array to a class for which "bitshift" is defined.
   cx = class(x);
   if strncmp(cx, 'int', 3)
      x = feval(['u', cx], x);          % "int8" -> "uint8" etc.
   elseif strcmp(cx, 'single')
      x = double(x);                    % "single" -> "double"
   end

   % Convert from char array to double if necessary.
   if ischar(x)
      v = [2 1 3:ndims(x)];
      x = permute(x, v);
      x = sscanf(x, '%1x');
      x = permute(reshape(x, sx(v)), v);
   end

   hi = bitshift(x(:,1:2:end,:), 4);    % high 4 bits
   lo = x(:,2:2:end,:);                 % low 4 bits
   y = bitor(hi, lo);
   y = reshape(y, sy);
