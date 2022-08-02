function [S,esterr] = sqrtm(A)
%SQRTM	Matrix square root.
%	S = SQRTM(A) is the matrix square root of A.
%	Complex results are produced if A has negative eigenvalues.
%	A warning message is printed if the computed S*S is not close to A.
%
%	[S,esterr] = sqrtm(A) does not print any warning message, but
%	returns an estimate of the relative residual, norm(S*S-A)/norm(A).
%
%	If A is real, symmetric and positive definite, or complex, Hermitian
%	and positive definite, then so is the computed matrix square root.
%
%	Some matrices, like A = [0 1; 0 0], do not have any square roots,
%	real or complex, and SQRTM cannot be expected to produce one.
%
%	See also EXPM, LOGM, FUNM.

%	CBM, 7-12-92.
%	Copyright (c) 1984-94 by The MathWorks, Inc.

% First try Parlett's method directly.
[S,esterr] = funm(A,'sqrt');
tol = 1000*eps;
% If funm's error estimate is small, accept the result.
if esterr >= tol
   % Use norm of residual instead of funm's crude error estimate.
   esterr = norm(S*S-A,1)/norm(A,1);
   if esterr >= tol
      [n,n] = size(A);
      % Try again with a not-quite-random rotation.
      R = orth(eye(n,n) + magic(n)/(n*(n*n+1)/2));
      [S,ignore] = funm(R*A*R','sqrt');
      S = R'*S*R;
      esterr = norm(S*S-A,1)/norm(A,1);
   end
end
if (esterr >= tol) & (nargout < 2)
   disp(' ')
   disp(['Warning: SQRTM appears inaccurate.  esterr = ',num2str(esterr)])
end
