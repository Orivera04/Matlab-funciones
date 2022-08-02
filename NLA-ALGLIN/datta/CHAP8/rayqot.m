function [sigma,x,iter] = rayqot(A,x0,ep,numitr) 
%RAYQOT Rayleigh quotient iteration 
%[sigma,x,iter] = rayqot(A,x0,ep,numitr) computes an approximate          
%eigenpair(sigma,x) of a matrix A using Rayleigh-Quotient iteration.
%x0 is the initial approximation to the eigen vector x.  ep is the tolerance
%numitr is the user-supplied number of iteration.  On output, if the
%Rayleigh quotient iteration converged, iter contains the iteration number
%needed to converge. If the iteration did not converge, iter contains
%the value of numitr.
%This program implements Algorithm 8.5.3 of the book.  
%input  : Matrix A, vector x0, scalar ep and integer numitr
%output : Scalar sigma, vector x and integer iter

	[m,n] = size(A);
        if m~=n
        	disp('matrix A  is not square')  ;
        	return;
        end;
        prevsig = 0;
        x = x0;
        for k = 0 :  numitr
         iter = k;
         sigma = (x'*A*x)/(x'*x);
         xhat = (A-sigma * eye(n,n))\x;
         x = xhat/max(xhat);
         if  norm( (A-sigma * eye(n,n))*x )  < ep
            return;
         end
         prevsig = sigma;
        end;
        end;
