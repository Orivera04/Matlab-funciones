function [V,lam] = quadeig1(M,D,K) 
%QUADEIG1 Quadratic Eigenvalue Problem via Standard Reduction 
%[V,lam] = quadeig1(M,D,K)  computes the eigenvalues and
%eigenvectors of the quadratic eigenvalue problem via 
%the reduction to a standard eigenvalue problem.
%The vector lam contains the eigenvalues and 
%matrix V the corresponding eigenvectors.
%See Section 9.8 of the book. 
%input  : Matrices M,D and K
%output : Matrix V and vector lam

        [m,n] = size(M);
        if m~=n
        	disp('matrix M  is not square')  ;
        	return;
        end;
         A = [zeros(n,n) eye(n,n) ; -inv(M)*K -inv(M) * D];
         [U,D] = eig(A);
          V = U(1:n,:);
          lam = diag(D);
