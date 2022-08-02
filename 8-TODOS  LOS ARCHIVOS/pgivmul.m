function A = pgivmul(A,i,j,c,s)
%PGIVMUL Premultiplication  by a Givens Matrix.
%A = pgivmul(A,i,j,c,s)  computes the premultiplication
%of the matrix A by the Givens matrix, J(i,j,theta), where
%1 <= i <=j <= m, and c = cos(theta), s = sin(theta).
%The output matrix A contains the product JA.
%This program implements Algorithm 5.5.2 of the book.
%Input   : Matrix A, Givens parameters c and s, indices i and j
%Output  : Matrix A

   	[m,n] = size(A);
        a1 = A(i,:);
        a2 = A(j,:);
        A(i,:) = c * a1 + s * a2;
        A(j,:) = -s * a1 + c * a2;
