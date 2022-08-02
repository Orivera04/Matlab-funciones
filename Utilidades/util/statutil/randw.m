function x = randw(w, s)
%RANDW Weighted random numbers from discrete distribution.
%
%   RANDW(W, [M N]) is an M-by-N matrix with random entries, chosen from a
%   discrete discrete distribution on the integers 1,...,LENGTH(W) where the
%   probability of a random entry being I is W(I)/SUM(W).
%
%   RANDW(W, [M N P ...]) generates a random array of any dimension.
%   RANDW(W) generates a scalar random variable.

%   Author:      Peter J. Acklam
%   Time-stamp:  2002-03-03 13:45:33 +0100
%   E-mail:      pjacklam@online.no
%   URL:         http://home.online.no/~pjacklam

   % Check input arguments.
   error(nargchk(1, 2, nargin));
   if isempty(w) | ( sum(size(w) > 1) > 1 )
      error('W must be a vector.');
   end
   if nargin < 2, s = 1; end
   if ( sum(size(s) > 1) > 1 ) | any(s(:) < 0) | any(s(:) ~= round(s(:)))
      error('S must be a vector of non-negative integers.');
   end

   % Get the size of the output array.
   switch length(s)
      case 0, s = 1;
      case 1, s = [s s];
   end
   n = prod(s);                 % sample size

   % Quick exit if output will be empty.
   if ~n
      x = zeros(s);
      return
   end

   % Calculate cumulative sum and normalize so it sums up to one.
   m = length(w);               % length of weight vector
   c = cumsum(w);               % cumulative sum
   if c(m) ~= 1                 % if weights don't sum up to 1
      c = c/c(m);               %   make sure they do
   end

   % Now generate the sample.
   r = rand(s);
   x = ones(s);
   for i = 1:m-1
      x = x + (r > c(i));
   end
