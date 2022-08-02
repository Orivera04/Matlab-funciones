function [A,U,M] = parpiv(A);
%PARPIV Triangularization using Gaussian Elimination with partial pivoting
%[A,U,M] = parpiv(A) produces an upper triangular matrix U 
%and a permuted lower triangular matrix M using
%partial pivoting, so that MA = U. The lower triangular part
%of the output matrix A contains the multiplers and the upper triangular part  
%contains U. 
%This program implements Algorithm 5.2.2 of the book. 
%input  : Matrix A
%output : Matrices A, U and M 

	[m,n] = size(A);
        if m~=n
        	disp('matrix T  is not square')  
        	return;
        end;
        M = eye(n,n);
        U = zeros(n,n);
	for k = 1:n-1
          M1 = eye(n,n);
          d = k ;
          s = A(k,k);
          for i = k+1:n
          if abs(A(i,k)) > abs(s)
             s = A(i,k);
             d = i;
          end;
          end;
         if (s == 0)
          disp('the algorithm has encountered a zero pivot')
          A =[];
          U =[];
          M =[];
          return;
         end;
	 p(k) = d;
          if d ~= k
           [A(k,k:n),A(d,k:n)] = inter(A(k,k:n),A(d,k:n));
           [M(k,:),M(d,:)] = inter(M(k,:),M(d,:));
	  end;
          M1(k+1:n,k) = -A(k+1:n,k)/A(k,k);
          A(k+1:n,k) = M1(k+1:n,k);
            A(k+1:n,k+1:n) = A(k+1:n,k+1:n) +M1(k+1:n,k) * A(k,k+1:n);
%------------updating M---------
           M(k+1:n,1:n) = M(k+1:n,1:n) +M1(k+1:n,k) * M(k,1:n);
%-end updating
	end; 
        U = triu(A);
        end;
