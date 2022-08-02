function x = gausswf(A,b);
%GAUSSWF  Linear system solution without explicit factorization
%x = gausswf(A,b) computes the solution x of the system Ax = b
%using Gaussian elimination with partial pivoting.  The factorization 
%MA = U is never explicitly formed. 
%The program calls the MATCOM program BACKSUB and INTER.
%The program implements Algorithm 6.4.2 of the book.
%input  : Matrix A and vector b
%output : vector x

	[m,n] = size(A);
        if m~=n
        	disp('matrix A  is not square')  
        	return;
        end;
        s1 = b ;
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
            disp('the algorithm has encountered a zero pivot');
            x =[];
            return;
          end;
	 p(k) = d;
          if d ~= k
           [A(k,k:n),A(d,k:n)] = inter(A(k,k:n),A(d,k:n));
           [b(k),b(d)] = inter(b(k),b(d));
	  end;
          M1(k+1:n,k) = -A(k+1:n,k)/A(k,k);
          A(k+1:n,k) = M1(k+1:n,k);
            A(k+1:n,k+1:n) = A(k+1:n,k+1:n) +M1(k+1:n,k) * A(k,k+1:n);
            b(k+1:n)   = b(k+1:n) + M1(k+1:n,k) * b(k);
	end; 
        U = triu(A);
        x = backsub(U,b);
        end;
