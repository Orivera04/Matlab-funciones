function [Q,R,A,v] = housqrn(A) 
%HOUSQRN Householder QR factorization of a nonsquare matrix  
%[Q,R,A,v] = housqrn(A) produces an orthogonal matrix Q
%and an upper triangular matrix R of the same size as 
%A with zeros below the diagonal, so that A = QR, using
%Householder matrices.  The upper triangular part of
%the output matrix A contains R, and the lower triangular part
%contains the components u_k+1,k through u_nk of the
%vectors u_n-k=1 = (u_kk, .... u_nk)'.  The output vector v
%contains first components u_kk of the vector u_n-k+1.  
%This program calls MATCOM programs HOUSZERO and HOUSMULP.
%see Section 5.4.2 of the book.
%input   : Matrix A
%output  : Matrices Q, R, A and vector v   

	[m,n] = size(A);
        S= min(n,m-1);
        Q = eye(m,m);
        for k = 1 : S
          [x,sigma] = houszero(A(k:m,k));
          Q(1:m,k:m) = housmulp(Q(1:m,k:m),x);
          A(k,k) = sigma ;
          s1 = size(x);
          A(k+1:m,k) = x(2:s1);
          v(k) = x(1);
          beta = 2/(x'*x);
            for j = k+1:n
              s = 0;
              s = s + x(1:m-k+1)' * A(k:m,j);
              s = beta * s;
              A(k:m,j) = A(k:m,j) - s * x(1:m-k+1);
              end;
           end;
    R = triu(A);
        end;
