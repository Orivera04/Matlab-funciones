function T = inparpiv(A);
%INPARPIV Inverse by partial pivoting 
%T = inparpiv(A) computes the inverse T of a matrix A using Gaussian
%elimination with partial pivoting : inv(A) = inv(U) * M
%This program uses MATCOM program PARPIV.
%input  : Matrix A
%output : Matrix T

	[m,n] = size(A);
        if m~=n
        	disp('matrix A  is not square')  ;
        	return;
        end;
	[C,U,M] = parpiv(A);
	T = (U) \ M;
        end;
