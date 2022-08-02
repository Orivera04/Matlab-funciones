function A = phousmul(A,u) 
%PHOUSMUL Pre Multiplication By Householder Matrix
%A = phousmul(A,u) computes the pre-multiplication
%of a matrix A by the Householder matrix generated
%by the vector u. The output matrix A contains the product HA. 
%This program implements Algorithm 4.2.1 of the book. 
%input   : Matrix A and vector u
%output  : Matrix A 

	[m,n] = size(A);
        beta = 2/(u'*u);
        for j = 1 : n
          alpha = 0;
          alpha =  alpha + u(1:m)'*A(1:m,j);
          alpha =  beta * alpha;
          A(1:m,j) = A(1:m,j) - alpha * u(1:m);
         end;
