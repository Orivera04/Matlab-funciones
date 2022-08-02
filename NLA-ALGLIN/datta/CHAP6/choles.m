function [A,H] = choles(A);
%CHOLES Cholesky factorization 
%[A,H] = choles(A) computes the Cholesky factorization of a
%symmetric positive matrix A : A = HH'. H is a lower triangular
%matrix with positive diagonal entries. On output, the lower 
%triangular part ofthe output matrix A contains H.  Note that MATLAB CHOL(A)
%produces an upper triangular matrix R such that R'*R = A. This
%program implements Algorithm 6.4.4 of the book.
%input  : Matrix A
%output : Matrices A and H

	[m,n] = size(A);
        if m~=n
        disp('matrix A  is not square');
        return;
        end;
	for k = 1:n
	  for i = 1:k-1
          sum = 0;
	  if (i ~= 1)
	     sum =A(i,1:i-1)*A(k,1:i-1)';
          end;
	    A(k,i) = (A(k,i) - sum)/A(i,i);
	  end
          sum = 0;
	  if (k ~= 1)
	    sum =A(k,1:k-1)*A(k,1:k-1)';
	  end;
	  A(k,k) = (A(k,k) - sum) ^ 0.5;
	end
        H = tril(A);
        end;
