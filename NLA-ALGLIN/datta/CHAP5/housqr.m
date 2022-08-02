function [Q,R,A,v] = housqr(A) 
%HOUSQR Householder QR factorization 
%[Q,R,A,v] = housqr(A) produces an orthogonal matrix Q
%and an upper triangular matrix R so that A = QR, using
%Householder matrices.  The upper triangular part of
%the output matrix A contains R, and the lower triangular part
%contains the components u_k+1,k through u_nk of the
%vectors u_n-k=1 = (u_kk, .... u_nk)'.  The output vector v
%contains first components u_kk of the vector u_n-k+1.  
%This program calls MATCOM programs HOUSZERO and HOUSMULP.
%This program implements Algorithm 5.4.3 of the book.
%input  : A square matrix A
%output : Matrices Q, R, A and vector v

	[m,n] = size(A);
        Q = eye(m,m);
        for k = 1 : n-1
          [x,sigma] = houszero(A(k:n,k));
          Q(1:n,k:n) = housmulp(Q(1:n,k:n),x);
          A(k,k) = sigma;
          s1 = size(x);
          A(k+1:n,k) = x(2:s1) ;
          v(k)  = x(1);
          beta  = 2/(x' * x);
          for j = k + 1 : n
               s = 0;
               s = s + x(1:n-k+1)' * A(k:n,j);
             s = beta * s;
             A(k:n,j) = A(k:n,j) - s  * x(1:n-k+1);
          end;
        end;
        R = triu(A);
        end;
