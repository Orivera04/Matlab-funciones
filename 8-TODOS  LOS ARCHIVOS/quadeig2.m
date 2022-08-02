function [V,lam] = quadeig2(M,D,K) 
%QUADEIG2 Quadratic Eigenvalue Problem via Reduction to a Generalized Eigenvalue Problem 
%[V,lam] = quadeig2(M,D,K)  computes the eigenvalues and
%eigenvectors of the quadratic eigenvalue problem via 
%reduction to a generalized eigenvalue problem.
%The vector lam contains the eigenvalues and the
%matrix V contains the corresponding eigenvectors.
%See Section 9.8 of the book. 
%input  : Matrices M,D and K
%output : Matrix V and vector lam

        [m,n] = size(M);
        if m~=n
        	disp('matrix M  is not square')  ;
        	return;
        end;
        B = [D K; K zeros(n,n)];
        C = [-M zeros(n,n); zeros(n,n) K];
        [U,D1] = eig(B,C);
        lam = diag(D1);
        V = U(1:n,:);
