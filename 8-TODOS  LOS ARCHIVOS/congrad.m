function [x,iter] = congrad(A,x0,b,ep,numitr)
%CONGRAD  Classical conjugate gradient method
%[x,iter] = congrad(A,x0,b,ep,numitr) computes the solution x 
%of a symmetric positive definite linear system Ax = b using
%the Conjugate Gradient method. 
%x0 is the initial approximation, ep is the tolerance,
%and numitr is the user supplied number of iterations.
%If the conjugate-gradient method converged, iter contains
%the iteration number needed to converge.  If the conjugate-gradient method
%did not converge, iter contains numitr.  
%This program implements Algorithm 6.10.4 of the book.
%input  : Matrix A, vectors x0 and b, scalar ep, and integer numitr
%output : Vector x, and integer iter.

        [m,n]=size(A);
        p = b - A * x0;
        r = p;
        for k = 1 :  numitr
          iter = k;
           w = A * p;
           conol = (norm(r))^2 ;
           alpha = conol/ (p' * w);
           x = x0 + alpha * p;
           rnew = r - alpha * w;
           conv = (norm(rnew))^2; 
         if conv < ep
          return;
         end ;
           beta = conv / conol;
           p    = rnew + beta * p;
           r = rnew;
         end;
        end;
