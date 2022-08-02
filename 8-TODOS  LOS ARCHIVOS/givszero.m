function A = givszero(i,j,A)
%GIVSZERO Givens specific zeroing in a vector.
%A = givszero(i,j,A) creates a zero in the (j,i)th position of a 
%matrix A using Givens rotation matrix J. The output matrix A 
%contains the product JA such that its (j,i)th entry is
%zero.  This program calls the MATCOM program PGIVMUL and 
%GIVZERO.
%This program implements Algorithm 5.5.3 of the book.
%input   : Integers i, j and Matrix A
%output  : Matrix A

   	[m,n] = size(A);
        x = zeros(2,1);
        x(1) = A(i,i);
        x(2) = A(j,i);
        [c,s] = givzero(x);
	A = pgivmul(A,i,j,c,s);
