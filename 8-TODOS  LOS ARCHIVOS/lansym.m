function [V,T] = lansym(A,v1,k)
%LANSYM  Symmetric Lanczos algorithm
% [V,T] = lansym(A,v1,k) computes a k x k symmteric tridiagonal matrix 
%T and an orthonormal matrix V using the Lanczos
%algorithm.  Matrix A is symmetric and v1 is a unit vector.  
%Integer k is the number of basis vectors v1,v2, ... 
%to be computed.  This program implements Algorithm 8.12.2
%of the book.
%Input  : Matrix A, vector v1 and integer k
%Output : matrices V and T

     [m,n] = size(A);
      v0 = zeros(m,1);
      bet = 1;
      r = v1;
      vol = v0;
      for j = 1:k
        v = r/bet;
        V(:,j) = v;
        u = A * v;
        rnew = u - bet * vol;
        alph = v'*u;
        alpha(j) = alph;
        rnew = rnew - alph * v;
        bet = norm(rnew);
        beta(j) = bet;
        r = rnew;
        vol = v;
      end;
      T = diag(alpha(1:k))+ diag(beta(1:k-1),1)+diag(beta(1:k-1),-1);
      end;
