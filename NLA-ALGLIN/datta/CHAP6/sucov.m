function [x,iter] = sucov(A,x0,b,w,ep,numitr);
%SUCOV Successive overrelaxation
%[x,iter] = sucov(A,x0,b,w,ep,numitr) computes the solution x
%of the linear system Ax = b using the successive
%overrelaxation iterative method.  x0 is the initial
%solution, numitr is the number of iterations to be performed,
%specified by the user and w is the relaxation
%parameter. (w > 1). If w = 1 then the successive
%overrelaxation iterative method reduces to the
%Gauss-Seidel iterative method. ep is the tolerance
%If the successive overrelaxation method converged,
%iter contains the iteration number needed to converge. If the successive
%overrelaxation method did not converge, iter contains
%numitr.
%This program implements Algorithm 6.10.3 of the book.
%input  : Matrix A, vectors x0 and b, scalars w and ep and integer numitr
%output : vector x and integer iter


	[m,n] = size(A);
        if m~=n
        	disp('matrix A  is not square')  ;
        	return;
        end;
        xnew = zeros(m,1);
        x = x0;
        for k = 1 : numitr 
         iter = k;
         for i = 1:n
          s1 = 0;
          if i ~= 1
            s1 = A(i,1:i-1) * xnew(1:i-1);
          end;
          s2 = 0;
          if (i~=n)
            s2 = A(i,i+1:n) * x(i+1:n) ;
          end;
           xnew(i) = (w/A(i,i))*(b(i) - s1 - s2) + (1 - w) *x(i);
         end;
         if (norm(xnew - x) / norm(x) ) < ep
          x = xnew ;
          return;
         end
          x = xnew;
        end;
