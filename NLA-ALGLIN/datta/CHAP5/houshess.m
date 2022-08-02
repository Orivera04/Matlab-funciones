function [H,P,A,v] = houshess(A) 
%HOUSHESS Householder Hessenberg reduction 
%[H,P,A,v] = houshess(A) produces an upper Hessenberg matrix H from A
%using the Householder method such that H is orthogonally similar to A.
%PAP' = H.          
%The upper Hessenberg part of the output matrix A
%contains the upper Hessenberg matrix H, and the lower Hessenberg
%part contains the components u_k+2,k, through u_n,k of the
%vectors u_n-k = (u_k+1,k, ..., u_n,k)', k = 1, ... n-2.
%The output vector v contains the first components
%u_k+1,k of the vector u_n-k.  This program calls 
%the MATCOM programs HOUSZERO and HOUSMULP.
%This program implements Algorithm 5.4.4 of the book. 
%The matrix P is also explicitly formed.  
%input  : Matrix A
%output : Matrices H, P, A and vector v

	[m,n] = size(A);
        P = eye(m,m);
        for k = 1 : n-2
          [u,sigma] = houszero(A(k+1:n,k));
          A(k+1,k) = sigma;
          s1 = size(u);
          A(k+2:n,k) = u(2:s1);
          v(k) = u(1);
          beta = 2/(u'*u);
          for j = k+1:n
            s = 0;
               s = s + u(1:n-k)' * A(k+1:n,j);
            s = s * beta;
              A(k+1:n,j) = A(k+1:n,j) - s * u(1:n-k);
           end;
          for i = 1:n

            s = 0;
               s = s + u(1:n-k) * A(i,k+1:n);
            s = s * beta;
              A(i,k+1:n) = A(i,k+1:n) - (s * u(1:n-k))';
           end;
           A;
          P(1:n,k+1:n) = housmulp(P(1:n,k+1:n),u);
        end;
        H = triu(A,-1);
	P = P';
        end;

