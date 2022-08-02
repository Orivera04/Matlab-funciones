function s = commaint(x, sep)
%COMMAINT Insert commas between each thousand in an integer.
%
%   COMMAINT(X) returns X as a string with commas inserted before each
%   thousand.  COMMAINT(X, SEP) inserts SEP before each thousand.
%
%   Examples:
%
%      commaint(3141592)        returns  '3,141,592'
%      commaint(-3141592, '.')  returns  '-3.141.592'
%
%   See also SPRINTF, FPRINTF.

%   Author:      Peter J. Acklam
%   Time-stamp:  2003-10-13 16:51:58 +0200
%   E-mail:      pjacklam@online.no
%   URL:         http://home.online.no/~pjacklam

   nargsin = nargin;
   error(nargchk(1, 2, nargsin));

   if ~isnumeric(x) | any(size(x) ~= 1) | imag(x)
      error('X must be a real scalar integer.');
   end

   if nargsin < 2
      sep = ',';
   else
      if ~ischar(sep) | any(size(sep) ~= 1)
         error('SEP must be a string (char array) of length 1.');
      end
   end

   s = sprintf('%.f', abs(x));          % convert to string
   n = length(s);                       % number of chars in string
   m = ceil(n/3);                       % number of triples rounded upwards
   p = 3*ceil(n/3) - n + 1;
   c = zeros(3, m);                     % initialize new matrix

   c(p:end) = s;
   c(4,:) = sep;
   s = char(c(p:end-1));
   s = reshape(s, [1 length(s)]);

   if x < 0
      s = ['-' s];
   end
