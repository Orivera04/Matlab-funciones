function  C = covsvd(A)
%COVSVD  Variance-Covariance matrix
%C = covsvd(A) computes the variance covariance matrix 
%inv(A'*A) using the SVD of A.   
% see section 10.7 of the book.
%input  : Matrix A
%output : Matrix C
        
	[U,S,V] = svd(A);
        [m,n] = size(A);
	[U,S,V] = svd(A);
        r = 0;
        for i = 1:n
         if S(i,i) > 10^(-15)
           r = r+1;
         else
           i = n;
         end;
        end;
	for i = 1:n
         for j = 1:n
          sum = 0;
	  for k = 1:r
	    sum = sum + V(i,k) * V(j,k) / (S(k,k) * S(k,k));
          end;
          C(i,j) = sum;
         end;
        end;
        end
