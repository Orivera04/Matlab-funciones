function  r = gensturm(A,B)
%GENSTURM Sturm sequence method
% r = gensturm(A,B)
%Given A and B n x n matrices, the algorithm computes
%the eigenvalues of the symmetric definite tridiagonal
%pencil (A - lambda B) by computing the zeros of Pn(lamda).
%Matrices A and B are both symmetric tridiagonal
%and B is positive definite.  See Section 9.9.1 of the book.
%input  : Matrices A and B
%output : Vector r 

        
	[m,n] = size(A);
        p0 = 1;
        p1 = [-B(1,1); A(1,1)];
        for r = 2:n
           pnew1 = A(r,r) * [0;p1] - B(r,r) * [p1;0] ;
           pnew2 = -(A(r,r-1)^2*[0;0;p0] -2*A(r,r-1)*B(r,r-1)*[0;p0;0]);
           pnew3 = -(+B(r,r-1)^2 *[p0;0;0]);
           pnew =  pnew1 + pnew2 + pnew3;
           p0 = p1;
           p1 = pnew;
         end;
          r = roots(pnew);
         end;
