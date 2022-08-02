function x  = gauss(A,b) 
%GAUSS	Linear system solution using Gaussian elimination with economy in storage 
%x = gauss(A,b) computes the solution x of the linear
%system Ax = b using Gaussian Elimination.  The upper triangular
%part of A is overwritten by the triangular matrix produced at the end of the 
%(n-1)th step and the multipliers are stored in the lower triangular part of A. 
%On output b contains the final transformed vector.  
%This program calls the MATCOM program BACKSUB.
%This program implements Algorithm 4.2.3 of the book.
%input  : Matrix A and vector b 
%output : vector x

	[m,n] = size(A);
        for k = 1 : n-1 
            if (A(k,k) == 0)
              disp('the algorithm has encountered a zero pivot')
              x=[];
              return;
            end;
             A(k+1:n,k) =  -A(k+1:n,k)/ A(k,k);
             b(k+1:n) = b(k+1:n) + A(k+1:n,k) * b(k);
             A(k+1:n,k+1:n)  = A(k+1:n,k+1:n)  + A(k+1:n,k) * A(k,k+1:n);
        end;
        U = triu(A);
        x = backsub(U,b);
