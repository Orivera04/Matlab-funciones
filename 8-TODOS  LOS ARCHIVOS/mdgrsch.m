function [Q,R] = mdgrsch(A);
%MDGRSCH Modified Gram-Schmidt for QR factorization 
%[Q,R] = mdgrsch(A) computes the QR factorization of an m x n matrix A
%using the modified Gram-Schmidt method : A = QR, R is n x n upper
%triangular and Q is m x n and has orthonormal columns.
%This program implements Algorithm 7.8.4 of the book.
%input   : Matrix A
%output  : Matrices Q and R

	[m,n] = size(A);
        Q(:,1:n) = A(:,1:n);
 	for k = 1 :n
	  R(k,k) = norm(Q(:,k));
          Q(:,k) = Q(:,k) /R(k,k);
          for j = k+1:n
              R(k,j) = Q(:,k)'*Q(:,j);
              Q(:,j) = Q(:,j) - R(k,j) * Q(:,k);
          end;
        end;
        end;
