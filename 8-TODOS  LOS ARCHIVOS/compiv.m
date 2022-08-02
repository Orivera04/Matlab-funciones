function [A,U,M,Q] = compiv(A);
%COMPIV	Triangularization using Gaussian elimination with complete pivoting 
%[A,U,M,Q] = compiv(A) produces an upper triangular matrix U,
%a permuted lower triangular matrix M,  and a permutation matrix Q,
%using complete pivoting so that MAQ = U.  The lower triangular part
%of the output matrix A contains the multipliers and the upper
%triangular part of A contains U.
%This program implements Algorithm 5.2.3 of the book.
%input  : Matrix A
%output : Matrices A, U, M and Q.  

	[m,n] = size(A);
        if m~=n
        	disp('matrix A  is not square')  
        	return;
        end;
        M = eye(n,n);
        Q = eye(n,n);
        U = zeros(n,n);
	for k = 1:n-1
        M1 = eye(n,n);
          d = k ;
          e = k;
          s = A(k,k);
          for i = k:n
           for j =  k : n
             if abs(A(i,j)) > abs(s)
             s = A(i,j);
             d = i;
             e = j;
          end;
          end;
          end;
         if  s == 0  
          disp('the algorithm has encountered a zero pivot')
          A=[];
          U=[];
          M=[];
          Q=[];
          return;
         end
	 p(k) = d;
          if (d ~= k | e ~=k)
           [A(k,k:n),A(d,k:n)] = inter(A(k,k:n),A(d,k:n));
           [Q(:,k),Q(:,e)] = inter(Q(:,k),Q(:,e));
           [A(:,k),A(:,e)] = inter(A(:,k),A(:,e));
            [M(k,:),M(d,:)] = inter(M(k,:),M(d,:));
	  end;
          M1(k+1:n,k) = -A(k+1:n,k)/A(k,k);
          A(k+1:n,k) = M1(k+1:n,k);
            A(k+1:n,k+1:n) = A(k+1:n,k+1:n) +M1(k+1:n,k) * A(k,k+1:n);
%-updating M---
            M(k+1:n,1:n) = M(k+1:n,1:n) +M1(k+1:n,k) * M(k,1:n);
%----
	end; 
        U = triu(A);
        end;

