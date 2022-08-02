function Q = orth(A)
%ORTH	Orthogonalization.
%	Q = orth(A) is an orthonormal basis for the range of A.
%	Q'*Q = I, the columns of Q span the same space as the columns
%	of A and the number of columns of Q is the rank of A.
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
Q = U(:,1:r);

%-------------
%
% Here is the old code.  Use it for faster computation, or for
% generating the same results as earlier versions of MATLAB.
%
%   % QR decomposition
%   [Q,R,E]=qr(A);
%   % Determine r = effective rank
%   tol = eps*norm(A,'fro');
%   r = sum(abs(diag(R)) > tol);
%   r = r(1); % fix for case where R is vector.
%   % Use first r columns of Q.
%   if r > 0
%      Q = Q(:,1:r);
%      % Cosmetic sign adjustment
%      Q = -Q;
%      Q(:,r) = -Q(:,r);
%   else
%      Q = [];
%   end
