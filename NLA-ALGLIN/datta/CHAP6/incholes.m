function T = incholes(A);
%INCHOLES Inverse of a symmetric positive definite matrix using Cholesky factorization 
%T = incholes(A) computes the inverse of a symmetric positive 
%definite matrix A using its Cholesky factor H.
%inv(A) = inv(H')inv(H). 
%This program calls the MATCOM program CHOLES.
%See section 6.5.3 of the book.
%input  : Matrix A
%output : Matrix T

	[m,n] = size(A);
        if m~=n
        	disp('matrix A  is not square')  ;
        	return;
        end;
	[C,H] = choles(A);
	Hinv = inv(H);
	T = Hinv'*Hinv;
        end;

