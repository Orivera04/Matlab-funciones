function Z = null(A) 
%NULL	Null space.
%	Z = null(A) is an orthonormal basis for the null space of A.
%	Z'*Z = I, A*Z has negligible elements, and the number of columns
%	of Z is the nullity of A.
%
%	See also SVD, ORTH, RANK.

%	Major revision, 4-13-93, C. Moler.
%	Copyright (c) 1984-94 by The MathWorks, Inc.

% Beginning with MATLAB 4.1, the algorithms for NULL and ORTH 
% use singular value decomposition, SVD, instead of orthogonal
% factorization, QR.  This doubles the computation time, but
% provides more reliable and consistent rank determination.

[U,S,V] = svd(A,0);
[m,n] = size(A);
if m ~= 1, s = diag(S); else, s = S(1,1); end
tol = max(m,n) * max(s) * eps;
r = sum(s > tol);
Z = V(:,r+1:n);

%-------------
%
% Here is the old code.  Use it for faster computation, or for
% generating the same results as earlier versions of MATLAB.
%
%   % QR decomposition of the transpose.
%   [Q,R,E]=qr(A');
%   % Determine effective nullity
%   tol = eps*norm(A,'fro');
%   [m,n] = size(A);
%   if m > 1
%      d = sum(abs(R'));
%   else
%      d = abs(R');
%   end
%   nul = find(d <= tol);
%   % Use nul columns of Q.
%   if length(nul > 0)
%      Z = Q(:,nul);
%   else
%      Z = [];
%   end
