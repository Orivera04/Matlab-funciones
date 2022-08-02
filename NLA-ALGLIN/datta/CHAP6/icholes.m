function [A,L] = icholes(A);
%ICHOLES Incomplete Cholesky factorization 
%[A,L] = icholes(A) produces the incomplete Cholesky factor A of
% a sparse symmetric positive definite matrix A.  The program implements
% Algorithm 6.10.6 of the book.
%input  : Matrix A
%output : Matrices A and L

	[m,n] = size(A);
        if m~=n
        	disp('matrix A  is not square');
        	return;
        end;
        L = eye(n,n);
        L(1,1) = A(1,1) ^ 0.5;
	for i = 2:n
	  for j =  1:i-1
	    if A(i,j) == 0;
	       L(i,j) = 0;
	    else
	       sum = 0;
	       for k = 1:j-1
                   sum = sum + L(i,k)*L(j,k);
	       end;
	       L(i,j) = (A(i,j) - sum)/L(j,j);
            end;
          end;
	  sum = 0;
	  for k = 1:i-1
              sum = sum + L(i,k) * L(i,k);
          end
	  L(i,i) = (A(i,i) - sum) ^ 0.5;
	end;
	end;
