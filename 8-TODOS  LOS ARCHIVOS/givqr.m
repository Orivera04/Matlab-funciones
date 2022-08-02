function [Q,R] = givqr(A)
%GIVQR	QR factorization by Givens rotation 
%[Q,R] = givqr(A) produces  an orthogonal matrix Q
%and a matrix R of the same size as A 
%with zeros below the diagonal, such that A = QR,
%using Givens rotations.
%This program calls MATCOM program GIVZERO.
%This program implements Algorithm 5.5.4 of the book and
%also explicitly computes Q and R.
%input  : Matrix A
%output : Matrices Q and R 

        [m,n] = size(A);
        Q = eye(m,m);
        for k= 1:min(n,m-1)
         for l = k+1:m
           x=[A(k,k) A(l,k)]';
           [c,s] = givzero(x);
           A1 = c * A(k,:) + s*A(l,:);
           A2 =-s * A(k,:) + c *A(l,:);
           A(k,:) = A1;
           A(l,:) = A2;
           A3 = c * Q(:,k) + s*Q(:,l);
           A4 = -s * Q(:,k) + c *Q(:,l);
           Q(:,k) = A3;
           Q(:,l) = A4;
         end
        end 
        R = A;
        end;

