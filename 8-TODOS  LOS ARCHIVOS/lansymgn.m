function  [Vj,Tj] = lansymgn(A,B,v1,j)
%LANSYMGN  Lanczos Algorithm for Symmetric Definite Pencil
%[Vj,Tj] = lansymgn(A,B,v1,j) constructs a symmetric tridiagonal 
%matrix Tj 
%and an orthonormal matrix Vj = [v1,v2, ..., vj] such that
%Vj'AVj = Tj and Vj'BVj = I(jxj).  
%Matrices A and B are symmetric and B is positive definite.
%This program implements Algorithm 9.9.1 of the book.
%input  : Matrices A and B, vector v1, and integer j.
%output : Matrices Vj and Tj
        
	[m,n] = size(A);
        L = chol(B);
        L=L';
        bet = 1;
        r = v1;
        v0 = zeros(m,1);
        for i = 1:j
          if i == 1
           v = v1;	
          else
           v = B\( r /bet);
          end;
           Vj(:,i) = v;
           alph = v'*(A*v - B * v0);
           alpha(i) = alph;
           r  = A * v - alph * B * v - bet*B*v0;
           bet = norm(inv(L)*r);
           beta(i) = bet;
           v0 = v;
        end;
        Tj = diag(alpha(1:j)) +  diag(beta(1:j-1),1)  +  diag(beta(1:j-1),-1);
