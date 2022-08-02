function [x,iter] = invitr(A,x0, sigma, ep,  numitr) 
%INVITR Inverse iteration
%[x,iter] = invitr(A,x0, sigma, ep,  numitr) computes an approximation x, of the
%eigenvector corresponding to a given approximation sigma of an eigenvalue,
%using inverse iteration.  x0 is the initial approximation,
%ep is the tolerance and numitr is the maximum number of iterations.  
%If the iteration converged, iter is the number of iterations
%needed to converge.  If the iteration did not converge,
%iter contains numitr. 
%This program implements Algorithm 8.5.2 of the book.
%input  : Matrix A, vector x0, scalars sigma, ep and integer numitr
%output : vector x and integer iter

	[m,n] = size(A);
        if m~=n
        	disp('matrix A  is not square')  ;
        	return;
        end;
        x = x0;
        for k = 1 :  numitr
        iter = k;
        prevx = x;
         xhat = (A - sigma * eye(n,n))\ x;
         x = xhat/norm(xhat);
         if norm( (A - sigma*eye(n,n)) * x , inf) < ep
           return;
         end;
        end;
        end;

