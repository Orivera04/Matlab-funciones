function [x,iter] = jacobi(A,x0,b,ep,numitr);
%JACOBI Jacobi method 
%[x,iter] = jacobi(A,x0,b,ep,numitr) computes the solution x of Ax = b using
%the jacobi iterative method.  ep is the tolerance.  numitr is the 
%user supplied number of iteration.  x0 is the initial 
%approximate to the solution. 
%If the Jacobi method converged, iter contains the iteration number
%needed to converge.
%If the Jacobi method did not converge, iter contains numitr.
%This program implements Algorithm 6.10.1 of the book.
%input  : Matrix A and vectors x0 and b, scalar ep and integer numitr
%output : vector x and integer iter

	[m,n] = size(A);
        if m~=n
        	disp('matrix A  is not square')  ;
        	return;
        end;
        xnew = zeros(m,1);
        x = x0;
         for k = 1:numitr
           iter = k;
           for i = 1:n
            s = 0;
            for j = 1:n
             if (j ~= i)
              s = A(i,j) * x(j) + s;
             end;
            end;
             xnew(i) = (b(i) - s) / A(i,i);
          end;
           if (norm(xnew - x) / norm(x) ) < ep
            iter = k;
            x = xnew;
            return;
           end
            x = xnew;
        end;
        end;
