function [X,lam] = cholqr(A,B)
%CHOLQR  Cholesky-QR algorithm for the symmetric definite pencil
%[X,lam] = cholqr(A,B) computes the eigenvalues and  eigenvectors for the
%symmetric definite pencil (A - lambda B). Matrix X contains the eigenvectors 
% and the vector lam contains the eigenvalues. 
%A is symmetric and B is symmetric positive definite.
%This program calls the MATCOM program BACKSUB.
%This program implements Algorithm 9.5.1 of the book.
%input  : Matrices A and B
%output : Matrix X, and vector lam.

          [m,n] = size(A);
	  L = chol(B);
          L = L';
          D = inv(L);
          C = D * A * D';
          [Y,D] = eig(C);
          for i = 1:n
            X(:,i) = backsub(L',Y(:,i));
          end;
          lam = diag(D);
          end;
