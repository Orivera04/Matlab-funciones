function [lambda1,x,iter] = power(A,x0,ep,numitr) 
%POWER	Power method 
%[lambda1,x,iter] = power(A,x0,ep,numitr) computes the dominant
%eigenvalue lambda1 and the corresponding eigenvector using the
%power method.  x0 is the initial vector, ep is the
%tolerance and numitr is the
%maximum number of iterations.  On output, if the power method converged,
%iter contains the iteration number needed to converge.
%If the power method did not converge, iter contains  the value of numitr.
%This program implements Algorithm 8.5.1 of the book.
%input  : Matrix A, vector x0, scalar ep and integer numitr
%output : Scalar lambda1, vector x, and integer iter

        t1 = cputime;
	[m,n] = size(A);
        if m~=n
        	disp('matrix A  is not square')  ;
        	return;
        end;
        x = x0;
        xhat = x0;
        for k = 1 :  numitr
         iter = k;
         prevxhat = xhat;
         xhat = A* x;
         x = xhat/max(xhat);

           if norm( (A*x - max(xhat)*x) )  < ep
              lambda1 = max(xhat);
              return;
           end;
        end;
        lambda1 = max(xhat);
        t2 = cputime - t1;
        disp('the cpu time in seconds taken for this algorithm')
        t2
        disp('the flop count for this algorithm is')
        flps = flops
        end;
