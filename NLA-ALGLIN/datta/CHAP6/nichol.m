function [L,D] = nichol(A);
%NICHOL No-fill Incomplete LDL'. 
%[L,D] = nichol(A) computes the  no-fill incomplete Cholesky
%factorization of A, without any square roots :  A = LDL'. 
%This program implements Algorithm 6.10.7 of the book.
%input  : Matrix A
%output : Matrices L and D

	[m,n] = size(A);
        if m~=n
        	disp('matrix A  is not square')  ;
        	return;
        end;
        L = eye(n,n);
        D = eye(n,n);
        D(1,1) = A(1,1);
	for i = 2:n
           for j = 1:i-1
             if A(i,j) == 0
                L(i,j) = 0;
             else
               sum = 0     ;  
               for k = 1 : j-1
               sum = sum + L(i,k) * D(k,k) * L(j,k);
               end;
               L(i,j) = (A(i,j) - sum) / D(j,j);
             end;
           end;
	   sum = 0;
	   for k = 1 : i-1
	     sum = sum +   L(i,k) * L(i,k) * D(k,k);
	   end;
           D(i,i) = A(i,i) - sum;
         end;
        end;
