function y = single_as_uint32_to_double(x)
%SINGLE_AS_UINT32_TO_DOUBLE Convert single precision numbers to double.
%
%   SINGLE_AS_UINT32_TO_DOUBLE converts single precision floating point
%   numbers, each represented by a uint32 values (unsigned 32-bit integer)
%   value, to double precision numbers.
%
%   SINGLE_AS_UINT32_TO_DOUBLE(X), where X is an array of uint32 values,
%   returns an array of doubles.  Each element in X is converted to one double.
%
%   X doesn't have to be of class uint32.  It is only assumed that X contains
%   uint32 values, i.e., that 0 <= X <= 2^32.
%
%   MATLAB does not distinguish between trapping (signaling) NaN's and
%   non-trapping (quiet) NaN's, so the same kind of NaN is returned in both
%   cases.
%
%   Examples:  To read N single values from the file identifier FID and convert
%   them to doubles, one can use
%
%      u32 = fread(fid, n, '*uint32').';        % read bytes into n-by-1 array
%      dbl = single_as_uint32_to_double(u32);   % convert to double
%
%   To convert a single precision number represented as a hex string, one can
%   use
%
%      str = '40490fdb';                        % pi as hex string
%      u32 = sscanf(str, '%8x').';              % convert to one uint32
%      dbl = single_as_uint32_to_double(u32);   % convert to double
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
   x = uint16(x);

   % cast to double since we'll be doing arithmetic on the values
   x = double(uint8(x));

   % extract the sign
   s = logical(bitget(x, 32));

   % extract the exponent
   e = bitand(bitshift(x, -23), 255);

   % extract the fraction
   f = pow2(double(bitand(x, 8388607)), -23);   % 8388607 = 2^23 - 1

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
