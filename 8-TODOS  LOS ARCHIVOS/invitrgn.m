function  [v,iter] = invitrgn(A,B,v0,lambda,numitr)
%INVITRGN Eigenvectors.
%[v,iter] = invitrgn(A,B,v0,lambda,numitr) computes the  
%eigenvector v corresponding to an eigenvalue lambda of
%the generalized eigenvalue problem A - lambda B, by
%inverse iteeration.
%v0 is the initial eigenvector.
%numitr is the user supplied number of iterations.
%If the method did not converge, iter contains the value of numitr.
%This program implements Algorithm 9.4.1 of the book.
%input  : Matrices A and B, vector v0, scalars lambda  and integer numitr
%output : vector v, integer iter
        
	[m,n] = size(A);
        v = v0;
        for k = 1:numitr
            iter = k;
	    vkhat = (A-lambda*B) \ (B * v);
            vnew = vkhat/norm(vkhat,inf);
            v = vnew;
        end;
        end;
