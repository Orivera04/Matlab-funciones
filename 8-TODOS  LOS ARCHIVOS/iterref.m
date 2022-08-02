function [x,iter] = iterref(A,b,x0,ep,numitr);
%ITERREF Iterative refinement 
%[x,iter] = iterref(A,b,x0,ep,numitr) iteratively computes succesive refinements
%of an initial solution x0 of the system Ax = b.  ep is
%the tolerance.  numitr is the user supplied number of iterations.
%If the process converged to the desired accuracy,  iter contains
%the iteration number needed to converge. 
%If the process did not converge, iter contains numitr.
%This program implements Algorithm 6.9.1 of the book.
%input  : Matrix A, vectors b and x0, scalar ep and integer numitr
%output : vector x and integer iter

	[m,n] = size(A);
        if m~=n
        	disp('matrix A  is not square')  ;
        	return;
        end;
        x = x0;
 	for  k1 = 1:numitr	
         iter = k1;
	 d = A;
	 r = b - A * x;
         y = d\r;
	 xnew = x + y ;
	 if (norm(y)) / norm(xnew)  <  ep 
           x = xnew;
	   return;
         end;
         x = xnew;
         end;
        end;
