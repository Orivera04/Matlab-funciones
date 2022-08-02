function y = single_as_uint8_to_double(x)
%SINGLE_AS_UINT8_TO_DOUBLE Convert single precision numbers to double.
%
%   SINGLE_AS_UINT8_TO_DOUBLE converts single precision floating point numbers,
%   each represented by four uint8 values (unsigned 8-bit integers), to double
%   precision numbers.
%
%   SINGLE_AS_UINT8_TO_DOUBLE(X), where X is an N-by-4 matrix of uint8's,
%   returns an N-by-1 vector of doubles.  Each row vector in X is converted to
%   one double.
%
%   SINGLE_AS_UINT8_TO_DOUBLE(X), where X is an N-by-4*M-by-P-by-... array
%   returns an N-by-M-by-M-by-P-by... array of doubles.
%
%   X doesn't have to be of class uint8.  It is only assumed that X contains
%   uint32 values, i.e., that 0 <= X <= 2^8.
%
%   MATLAB does not distinguish between trapping (signaling) NaN's and
%   non-trapping (quiet) NaN's, so the same kind of NaN is returned in both
%   cases.
%
%   Examples:  To read N single values from the file identifier FID and
%   convert them to doubles, one can use
%
%      u8  = fread(fid, [4 n], '*uint8').';     % read bytes into n-by-4 array
%      dbl = single_as_uint8_to_double(u8);     % convert to double
%
%   To convert a single precision number represented as a hex string, one can
%   use
%
%      str = '40490fdb';                        % pi as hex string
%      u8  = sscanf(str, '%2x').';              % convert to four uint8's
%      dbl = single_as_uint8_to_double(u8);     % convert to double
%
%   See also HEX2NUM.

%       31  30      23 22             0
%    |-----|----------|----------------|
%    | SIGN|  EXPONENT|  FRACTION      |
%    -----------------------------------
%                      ^
%                      binary point
%
%   ------------------------------------------------------------------------
%   Field       Position    Width   Full name
%   ------------------------------------------------------------------------
%   sign        31          1       sign bit (0 == positive, 1 == negative)
%   exponent    30-23       8       exponent (biased by 127)
%   fraction    22-0        23      fraction (bits to right of binary point)

%   Author:      Peter J. Acklam
%   Time-stamp:  2003-11-17 10:20:13 +0100
%   E-mail:      pjacklam@online.no
%   URL:         http://home.online.no/~pjacklam

   % check number of input arguments
   error(nargchk(1, 1, nargin));

   % cast to appropriate uint class to truncate the values that are outside
   % the range of what can be represented with the uint class
   x = uint8(x);

   % cast to double since we'll be doing arithmetic on the values
   x = double(uint8(x));

   % see if the input array has the right number of columns
   sx = size(x);
   if rem(sx(2), 4)
      error('Number of columns must be a multiple of 4.');
   end

   % compute the size of the output array
   sy = sx;
   sy(2) = sy(2)/4;

   x = reshape(x, [sx(1), 4, prod(sx)/(sx(1)*4)]);

   % extract the sign
   s = logical(bitget(x(:,1,:), 8));

   % extract the exponent
   e =   pow2(bitand(x(:,1,:), 127),  1) ...
       + pow2(bitand(x(:,2,:), 128), -7);

   % extract the fraction
   f =   pow2(double(bitand(x(:,2,:), 127)),  -7) ...
       + pow2(double(       x(:,3,:))      , -15) ...
       + pow2(double(       x(:,4,:))      , -23);

   expmax    = 255;
   expoffset = 127;

   emax = e == expmax;          % exponent is max
   ezro = ~e;                   % exponent is zero

   % normalized number (exponent is neither zero nor max)
   % (most numbers are normalized; we handle exceptions below)
   y = pow2(1 + f, double(e) - expoffset);

   % signed infinity (exponent is max, fraction is zero)
   k = find(emax & ~f);
   if ~isempty(k)
      y(k) = Inf;
   end

   % not a number (exponent is max, fraction is non-zero);
   % 0 < f < 0.5: non-trapping (quiet) NaN
   % f >= 0.5:    trapping (signaling) NaN
   k = find(emax & f);
   if ~isempty(k)
      y(k) = NaN;
   end

   % denormalized number (exponent is zero, fraction is non-zero)
   k = find(ezro & f);
   if ~isempty(k)
      y(k) = pow2(f(k), 1 - expoffset);
   end

   % signed zero (exponent is zero, fraction is zero)
   k = find(ezro & ~f);
   if ~isempty(k)
      y(k) = 0;
   end

   % fix the sign
   y(s) = -y(s);

   % reshape to correct size
   y = reshape(y, sy);
