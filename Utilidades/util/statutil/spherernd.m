function x = spherernd(n, p)
%SPHERERND Uniformly distributed random numbers in/on a unit sphere.
%
%   SPHERERND(N) returns an N-by-3 array of 3-dimensional points where the
%   points are uniformly distributed inside a unit sphere.
%
%   SPHERERND(N, P) returns an N-by-P array of P-dimensional points where the
%   points are uniformly distributed inside a P-dimensional unit sphere.
%
%   The output from SPHERERND can easily be converted to an array of points
%   uniformly distributed on the surface of a sphere rather than uniformly
%   distributed inside a sphere.  This is done by dividing each tuple by its
%   distance from the origin:
%
%      X = spherernd(N, P);                             % inside sphere
%      X = X ./ repmat(sqrt(sum(X .* X, 2)), [1, P]);   % on sphere surface
%
%   See also RAND.

%   The acceptance ratio is PI / 6 = 0.5236

%   The volume, Vp, of a p-sphere, is related to the surface area, Sp, of a
%   p-sphere by
%
%      Vp  =  Sp * R^p / p
%
%   where Sp is
%
%      Sp = 2 * pi^(p/2) / gamma(p/2)
%
%   So when variables are drawn from a uniform distribution in the p-cube
%   [-1,1]^p, the ratio of those lying inside the p-sphere is the ratio of the
%   volume of the p-sphere and the volume of the p-cube
%
%      (2 * pi^(p/2) / gamma(p/2) / p) / 2^p
%
%      = pi^(p/2) / ( p * 2^(p-1) * gamma(p/2))
%
%   The rejection rate is the inverse, which is
%
%      p .* 2.^(p-1) .* gamma(p/2) ./ pi.^(p/2)

   nargsin = nargin;
   error(nargchk(1, 2, nargsin));

   if nargsin < 2
      p = 3;
   end

   rejection_rate = p .* 2.^(p-1) .* gamma(p/2) ./ pi.^(p / 2);

   x = zeros(n, p);
   n_got = 0;
   while 1
      n_missing = n - n_got;
      n_generate = ceil(rejection_rate * n_missing);
      y = 2 * rand(n_generate, p) - 1;
      y = y(sum(y .* y, 2) <= 1, :);
      n_new = size(y, 1);
      if n_new < n_missing
         x(n_got+1:n_got+n_new, :) = y;
         n_got = n_got + n_new;
      else
         x(n_got+1:n, :) = y(1:n_missing, :);
         break
      end
   end
