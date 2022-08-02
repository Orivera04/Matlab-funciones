function [x,iter] = gaused(A,x0,b,ep,numitr);
%GAUSED Gauss-Seidel method
%[x,iter] = gaused(A,x0,b,ep,numitr) computes the solution x of 
%the linear system Ax = b, using the Gauss-Seidel method.
%x0 is the initial approximation,  ep is the tolerance, numitr is the
%user supplied number of iterations.  If the Gauss-Seidel method
%converged, iter contains the number of iterations needed to converge.
%If the Gauss-Seidel method did not converge, iter contains numitr.
%This program implements Algorithm 6.10.2 of the book.
%input  : Matrix A, vectors x0 and b, scalar ep, and integer numitr 
%output : vector x and integer iter

	[m,n] = size(A);
        if m~=n
        	disp('matrix A  is not square')  
        	return;
        end;
        xnew = zeros(m,1);
        x = x0;
        for k = 1 : numitr 
         iter = k;
         for i = 1:n
          s1 = 0;
          s2 = 0;
          if (i ~= 1)
            s1 = A(i,1:i-1) * xnew(1:i-1); 
          end;
          if (i ~= n)
            s2 = A(i,i+1:n) * x(i+1:n);
	  end
           xnew(i) = (b(i) - s1 - s2) / A(i,i);
         end;
         if (norm(xnew - x) / norm(x) ) < ep
          x = xnew ;
          return;
         end
          x = xnew;
        end;
