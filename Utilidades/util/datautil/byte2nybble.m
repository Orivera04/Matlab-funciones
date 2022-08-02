function y = byte2nybble(x)
%BYTE2NYBBLE Convert bytes to nybbles.
%
%   BYTE2NYBBLE(X), where X is a row vector of integers in the range
%   0,1,...,255, returns a vector twice the length of the input vector where
%   each element has been split into two nybbles containing the high 4 bits
%   (shifted 4 bits) and low 4 bits respectively.
%
%   If X is an array, the same operation is performed on each row
%   X(I,:,J,K,...).
%
%   Example:
%
%     byte2nybble([ 0 255 127 4 ]) returns [ 0 0 15 15 7 15 0 4 ]
%
%   See also: NYBBLE2BYTE.

%   Author:      Peter J. Acklam
%   Time-stamp:  2004-02-05 18:24:31 +0100
%   E-mail:      pjacklam@online.no
%   URL:         http://home.online.no/~pjacklam

   % Check number of input arguments.
   error(nargchk(1, 1, nargin));

   % Check array class.
   if ~isnumeric(x)
      error('Input must be a numeric array.');
   end

   % Convert array to a class for which "bitshift" is defined.
   cx = class(x);
   if strncmp(cx, 'int', 3)
      x = feval(['u', cx], x);          % "int8" -> "uint8" etc.
   elseif strcmp(cx, 'single')
      x = double(x);                    % "single" -> "double"
   end

   % Compute the size of the output array.
   sy = size(x);
   sy(2) = 2 * sy(2);

   % initialize output
   y(prod(sy)) = feval(class(x), 0);
   y = reshape(y, sy);

   y(:,1:2:end,:) = bitshift(x, -4);    % higher 4 bits
   y(:,2:2:end,:) = bitand(x, 15);      % lower 4 bits
