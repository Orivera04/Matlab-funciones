function  x = minnmsvd(A,b)
%MINNMSVD Minimum norm least-squares solution using the SVD
%x = minnmsvd(A,b) computes the minimum norm least squares 
%solution x using the SVD of A.
%This program implements Algorithm 10.8.1 of the book to 
%compute the minimum-norm least-squares solution.
%input  : Matrix A and vector b 
%output : vector x
        
	[m,n] = size(A);
        y = zeros(n,1);
	[U,S,V] = svd(A);
        bprime = U' * b;
        r = 0;
        for i = 1:n
         if S(i,i) > 10^(-15)
          y(i) = bprime(i) / S(i,i);
         else
          y(i) = 0;
         end;
        end;
        x = V * y;
