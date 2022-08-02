function c = varfact(s)
%VARFACT Robust variance matrix factorization.
%
%   C = VARFACT(S) generates a transformation matrix C from the variance
%   matrix S by matrix factorization.  The output C satisfies C*C' = S.
%
%   The variance matrix is factorized by eigenvalue decomposition.  If any
%   eigenvalues are negative it is assumed that this is due to numerical
%   errors in the calculation of the variance matrix.  Any negative
%   eigenvalues are replaced by zeros.

%   Author:      Peter J. Acklam
%   Time-stamp:  2002-03-03 13:45:24 +0100
%   E-mail:      pjacklam@online.no
%   URL:         http://home.online.no/~pjacklam

   [eigvec, eigval] = eig(s);
   eigval = diag(eigval);

   k = find(eigval < 0);                % find negative eigenvalues
   if ~isempty(k)                       %   if any were found
      warning('Adjusting eigenvalues of variance matrix.');
      eigval(k) = zeros(size(k));       %   replace by zeros
   end

   c = eigvec * diag(sqrt(eigval));     % calculate factorized matrix
