function R = scalevar(S)
%SCALEVAR Scale variance matrix.
%
%   R = SCALEVAR(VAR) scales the variance matrix VAR so it has standard
%   deviations on the main diagonal and correlation coefficients elsewhere.
%
%   See also VAR2CORR.

%   Author:      Peter J. Acklam
%   Time-stamp:  2001-06-19 12:40:31 +0200
%   E-mail:      pjacklam@online.no
%   URL:         http://home.online.no/~pjacklam

   error(nargchk(1, 1, nargin));        % check number of input arguments

   R = zeros(size(S));                  % initialize output matrix
   v = diag(S);                         % variances
   k = find(v);                         % find non-zero variances

   if ~isempty(k)
      S_sub = S(k,k);                   % find non-singular submatrix
      sdev = sqrt(v(k));                % standard deviations
      D = diag(sdev);                   % make diagonal matrix
      R(k,k) = D\S_sub/D;               % calculate correlation matrix
      n = length(k);
      R(1:n+1:n^2) = sdev;              % standard deviations on diagonal
   end
