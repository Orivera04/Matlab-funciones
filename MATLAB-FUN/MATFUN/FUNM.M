function [F,esterr] = funm(A,fun)
%FUNM	Evaluate function of a matrix.
%	F = FUNM(A,'fun') or F = FUNM('fun',A), for a square matrix argument A,
%	evaluates the matrix function specified by 'fun'.   For example,
%	FUNM(A,'sin') is the matrix sine.  For matrix exponentials, logarithms
%	and square roots, use EXPM(A), LOGM(A) and SQRTM(A) instead.
%
%	FUNM uses a potentially unstable algorithm.  If A is close to a
%	matrix with multiple eigenvalues and poorly conditioned eigenvectors,
%	FUNM may produce inaccurate results.  An attempt is made to detect
%	this situation and print a warning message.  The error detector is
%	sometimes too sensitive and a message is printed even though the
%	the computed result is accurate.
%
%	[F,ESTERR] = FUNM(A,'fun') does not print any message, but returns
%	a very rough estimate of the relative error in the computed result.
%
%	If A is symmetric or Hermitian, then its Schur form is diagonal and
%	FUNM will be able to produce an accurate result.
%
%	S = SQRTM(A) and L = LOGM(A) use FUNM to do their computations,
%	but they can get more reliable error estimates by comparing S*S
%	and EXPM(L) with A.  E = EXPM(A) uses a completely different
%	algorithm.
%
%	See also EXPM, SQRTM, LOGM.

%	C.B. Moler 12-2-85, 7-21-86, 7-11-92.
%	Copyright (c) 1984-94 by The MathWorks, Inc.

% Allow input arguments in either order.

if isstr(A) & ~isstr(fun)
   t = fun; fun = A; A = t;
end

% Parlett's method.  See Golub and VanLoan (1983), p. 384.

[Q,T] = schur(A);
[Q,T] = rsf2csf(Q,T);
F = eval(['diag(',fun,'(diag(T)))']);
n = max(size(A));
dmin = abs(T(1,1));
for p = 1:n-1
   for i = 1:n-p
      j = i+p;
      s = T(i,j)*(F(j,j)-F(i,i));
      if p > 1
         k = i+1:j-1;
         s = s + T(i,k)*F(k,j) - F(i,k)*T(k,j);
      end
      d = T(j,j) - T(i,i);
      if d ~= 0 
         s = s/d;
      end
      F(i,j) = s;
      dmin = min(dmin,abs(d));
   end
end
F = Q*F*Q';

if dmin == 0, dmin = eps; end
esterr = min(1,max(eps,(eps/dmin)*norm(triu(T,1),1)));
if (nargout < 2) & (esterr > 1000*eps)
   disp(' ')
   disp(['WARNING: Result from FUNM may be inaccurate.' ...
          ' esterr = ' num2str(esterr)])
end
