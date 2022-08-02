function  [lamda,x,iter] = genrayqt(A,B,x0,ep,numitr)
%GENRAYQT Generalized Rayleigh quotient iteration
%[lamda,x,iter] = genrayqt(A,B,x0,ep,numitr) computes approximations to
%the eigenvectors and the eigenvalues of the symmetric definite
%pencil A - lambda B.  A is symmetric and B is positive definite.  
%x0 is chosen such that norm(x0) = 1. numitr is the user
%supplied number of iterations. ep is the tolerance.
%If the method converged, iter contains the number of iterations
%needed to converge.  If the method did not converge iter 
%contains the value of numitr.
%This program implements Algorithm 9.5.4 of the book.
%input  : Matrices A and B, vector x0, scalar ep and integer numitr
%output : Scalar lamda, vector x and integer iter.
        
	[m,n] = size(A);
        x = x0;
	for k = 1:numitr
           iter = k;
	   lamda = (x'*A*x) / (x'*B*x);
           xkhat = (A - lamda * B) \ (B * x);
           newxk = xkhat/norm(xkhat);
           if norm( (A - lamda * eye(n,n)) * newxk ) < ep
             return;
           end
           x = newxk;
        end
        end
