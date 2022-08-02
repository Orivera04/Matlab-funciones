function [L,esterr] = logm(A)
%LOGM	Matrix logarithm.
%	L = LOGM(A) is the matrix logarithm of A.
%	Complex results are produced if A has negative eigenvalues.
%	A warning message is printed if the computed expm(L) is not close to A.
%
%	[L,esterr] = logm(A) does not print any warning message, but 
%	returns an estimate of the relative residual, norm(expm(L)-A)/norm(A).
%
%	If A is real symmetric or complex Hermitian, then so is LOGM(A).
%
%	Some matrices, like A = [0 1; 0 0], do not have any logarithms,
%	real or complex, and LOGM cannot be expected to produce one.
%
%	See also EXPM, SQRTM, FUNM.

%	CBM, 7-12-92.
%	Copyright (c) 1984-94 by The MathWorks, Inc.

% First try Parlett's method directly.
[L,esterr] = funm(A,'log');
tol = 1000*eps;
% If funm's error estimate is small, accept the result.
if esterr >= tol
   % Use norm of residual instead of funm's crude error estimate.
   esterr = norm(expm(L)-A,1)/norm(A,1);
   if esterr >= tol
      [n,n] = size(A);
      % Try again with a not-quite-random rotation.
      R = orth(eye(n,n) + magic(n)/(n*(n*n+1)/2));
      [L,ignore] = funm(R*A*R','log');
      L = R'*L*R;
      esterr = norm(expm(L)-A,1)/norm(A,1);
   end
end
if (esterr >= tol) & (nargout < 2)
   disp(' ')
   disp(['Warning: LOGM appears inaccurate.  esterr = ',num2str(esterr)])
end
