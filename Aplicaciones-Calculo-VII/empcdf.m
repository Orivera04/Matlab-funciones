function [x, p] = empcdf(x)
%EMPCDF Empirical cumulative distribution function.
%
%   [X, P] = EMPCDF(X) is the empirical cumulative distribution function of the
%   sample in X, P(i) = P{X <= x(i)}.  X must be a vector.
%
%   For instance, to plot the empirical cdf for two small equal-size
%   samples, one may use
%
%      x = randn(10, 1);            % generate sample
%      [x, p] = empcdf(x);          % compute empirical cdf
%      stairs(x, p);                % plot the cdf
%      set(gca, 'YLim', [0 1]);     % make sure y-range is [0,1]

%   Author:      Peter J. Acklam
%   Time-stamp:  2003-11-04 10:25:42 +0100
%   E-mail:      pjacklam@online.no
%   URL:         http://home.online.no/~pjacklam

   nargsin = nargin;
   error(nargchk(1, 2, nargsin));

   sx = size(x);                % size of `x'
   dx = ndims(x);               % number of dimensions in `x'

   % get first non-singleton dimension, or 1 if none found
   if nargsin < 2
      k = find(sx ~= 1);
         if isempty(k)
         dim = 1;
      else
         dim = k(1);
      end
   else
      if any(size(dim) ~= 1) | dim < 1 | dim ~= round(dim)
         error('Dimension must be a scalar positive integer.');
      end
   end

   n = size(x, dim);
   x = sort(x, dim);

   p = (1:n)/n;
   siz = ones(1, dx);
   siz(dim) = n;
   p = reshape(p, siz);

   rep = sx;
   rep(dim) = 1;
   p = repmat(p, rep);
