function [X,E] = polyeig(A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,A10)
%POLYEIG Polynomial eigenvalue problem.
%	[X,E] = POLYEIG(A0,A1,..,Ap) solves the polynomial eigenvalue problem
%	of degree p:
%	    (A0 + lambda*A1 +  ... + lambda^p*Ap)*x = 0.   
%	The input is p+1 square matrices, A0, A1, ..., Ap, all of the same 
%	order, n.  The output is an n-by-n*p matrix, X, whose columns   
%	are the eigenvectors, and a vector of length n*p, E, whose
%	elements are the eigenvalues.
%	    for j = 1:n*p
%	       lambda = E(j)
%	       x = X(:,j)
%	       (A0 + lambda*A1 + ... + lambda^p*Ap)*x is approximately 0.
%	    end
%
%	Special cases:
%	    p = 0, polyeig(A), the standard eigenvalue problem, eig(A).
%	    p = 1, polyeig(A,B), the generalized eigenvalue problem, eig(A,-B).
%	    n = 1, polyeig(a0,a1,..,ap), for scalars a0, ..., ap, 
%	    is the standard polynomial problem, roots([ap .. a1 a0])
%
%	If both A0 and Ap are singular the problem is potentially ill-posed.
%	Theoretically, the solutions might not exist or might not be unique.
%	Computationally, the computed solutions may be inaccurate.  An attempt
%	is made to detect this situation, and a warning message may result.
%	If one, but not both, of A0 and Ap is singular, the problem is well
%	posed, but some of the eigenvalues may be zero or "infinite".

%	C. Moler, 5-5-93, 12-29-93.
%	Copyright (c) 1984-94 by The MathWorks, Inc.
 
% Build up two n*p-by-n*p matrices:
%    A = [A0   0   0   0]   B = [-A1 -A2 -A3 -A4]
%        [ 0   I   0   0]       [  I   0   0   0]
%        [ 0   0   I   0]       [  0   I   0   0]
%        [ 0   0   0   I]       [  0   0   I   0]

[n,n] = size(A0); 
p = nargin-1;   
A = eye(n*p,n*p);
A(1:n,1:n) = A0; 
if p == 0 
   B = eye(n,n); 
   p = 1;
else 
   B = diag(ones(n*(p-1),1),-n); 
   j = 1:n;
   for k = 1:p   
      Ak = eval(['A' int2str(k)]); 
      B(1:n,j) = -Ak;
      j = j+n; 
   end 
end 

% Use the QZ algorithm on the pair of matrices.

[alpha,beta,Q,Z,X] = qz(A,B);

% Extract and check the results.

X = X(1:n,:);
alpha = diag(alpha);
beta = diag(beta);
atol = 100*n*max(abs(alpha))*eps;
btol = 100*n*max(abs(beta))*eps;
E = zeros(n*p,1);
for j = 1:n*p
   if abs(alpha(j)) < atol & abs(beta(j)) < btol
     disp(' ')
     disp('Warning: Rank deficient generalized eigenvalue problem.')
     disp('Eigenvalues are not well determined.  Results may be inaccurate.')
   end
   E(j) = alpha(j)/beta(j);
end
