function x =  lsitrn1(A,b,numitr)
%LSITRN1 Linear system analog least-squares iterative refinement. 
%x =  lsitrn1(A,b,numitr) refines iteratively a computed least 
%squares solution of Ax = b. numitr is the  user supplied 
%number of iterations.
%This is the linear system analog iterative refinement
%for a least squares solution.  For another iterative
%refinement algorithm see LSITRN2.
%This program calls the MATCOM program LSFRQRH. 
%This program implements Algorithm 7.10.1
%of the book.
%input  : Matrix A, vector b, and integer numitr
%output : vector x

        [m,n] = size(A);
        xold = zeros(n,1);
        for e1 = 1:numitr
           r = b - A * xold;
           c = lsfrqrh(A,r);
           xold = xold + c;
        end; 
        x = xold;
        end;
