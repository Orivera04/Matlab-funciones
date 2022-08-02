function x =  lsfrmgs(A,b)
%LSFRMGS Least-squares solution by MGS.
%x = lsfrmgs(A,b) computes the least squares solution
%x of the full-rank overdetermined system Ax = b using modified
%Gram-Schmidt.
%This program calls the MATCOM programs BACKSUB and MDGRSCH. 
%This program implements Algorithm 7.8.5 of the book.
%input  : Matrix A and vector b
%output : vector x

        b1 = b;
	[m,n] = size(A);
	[Q,R] = mdgrsch(A);
        for k = 1:n
            del(k) = Q(:,k)'*b1;
            b1 = b1 - del(k) * Q(:,k);
        end;
        x = backsub(R,del);
        end;
