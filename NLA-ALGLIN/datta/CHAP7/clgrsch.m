function [Q,R] = clgrsch(A);
%CLGRSCH Classical Gram-Schmidt for QR factorization
%[Q,R] = clgrsch(A) computes the QR factorization
%of an m x n  matrix A using the classical Gram-Schmidt method : 
%A = QR, R is n x n upper triangular, Q is m x n and has orthonormal columns. 
%This program implements Algorithm 7.8.3 of the book.
%input   : Matrix A
%output  : Matrices Q and R

	[m,n] = size(A);
 	for k = 1 :n
	     R(1:k-1,k) = Q(:,1:k-1)'* A(:,k);
          sum = 0;
          for i = 1:k-1
            sum = sum+ R(i,k) * Q(:,i);
          end
          Q(:,k) = A(:,k) - sum;
          R(k,k) = norm(Q(:,k));
          Q(:,k) = Q(:,k) / R(k,k);
	end;
	end;
