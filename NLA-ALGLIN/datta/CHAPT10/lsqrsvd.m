function  x = lsqrsvd(A,b)
%LSQRSVD Least-squares solutions using the SVD
%x = lsqrsvd(A,b) computes the least squares solution x using the
%the SVD of A.
%This program implements Algorithm 10.8.1 of the book.
%input  : Matrix A and vector b 
%output : vector x
        
	[m,n] = size(A);
        y = zeros(n,1);
	[U,S,V] = svd(A);
        bprime = U' * b;
        for i = 1:n
         if S(i,i) > 10^(-15)
             y(i) = bprime(i) / S(i,i);
         else
             y(i) = rand(1);
         end;
        end;
        x = V * y;
        end
