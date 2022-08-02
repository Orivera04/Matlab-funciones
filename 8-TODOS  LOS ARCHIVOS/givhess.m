function [H,P] = givhess(A)
%GIVHS	Givens Hessenberg reduction 
%[H,P] = givhess(A) produces an upper Hessenberg matrix H
%and an orthogonal matrix P using the Givens
%method so that H is orthogonally similar to A.  PAP' = H.
%P is the product of (n-i+1) Givens rotations.
%This program implements Algorithm 5.5.4 of the book.
%input  : Matrix A
%output : Matrices H and P 

        [m,n] = size(A);
        P = eye(m,m);
        for p= 1: n-2
         for  q = p+2:n
           x=[A(p+1,p) A(q,p)]';
           [c,s] = givzero(x);
           k = p+1;
           l = q;
           p1 =  c * P(k,:) + s*P(l,:);
           p2 = -s * P(k,:) + c*P(l,:);
           P(k,:) = p1;
           P(l,:) = p2;
           a1 = c * A(k,:) + s*A(l,:);
           a2 =-s * A(k,:) + c *A(l,:);
           A(k,:) = a1;
           A(l,:) = a2;
           a3 = c * A(:,k) + s*A(:,l);
           a4 = -s * A(:,k) + c *A(:,l);
           A(:,k) = a3;
           A(:,l) = a4;
         end
        end 
        H = A;
        end;



