function r = polytrim(p)
%POLYTRIM Trim polynomial by stripping off leading zeros.
%
%   R = POLYTRIM(P) trims the polynomial P by stripping off unnecessary leading
%   zeros.
%
%   P is a vector of coefficients in decreasing order.

%   Author:      Peter J. Acklam
%   Time-stamp:  2004-02-03 22:00:23 +0100
%   E-mail:      pjacklam@online.no
%   URL:         http://home.online.no/~pjacklam

   % Check number of input arguments.
   error(nargchk(1, 1, nargin));

   % Check array class.
   if ~isnumeric(p)
      error('P must be a numeric array.');
   end

   % Check array size.
   if (ndims(p) ~= 2) | (size(p, 1) ~= 1)
      error('P must be row vector.');
   end

   k = find(p);         % Find non-zero coefficients.
   if isempty(k)        % If non were found...
      r = 0;            % ...return zero polynomial...
   else                 % or else...
      k = min(k);       % ...get index of first...
      n = length(p);    % ...get length of vector...
      r = p(k:n);       % ...and assign output polynomial.
   end
