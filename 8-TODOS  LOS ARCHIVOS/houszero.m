function [u,sigma] = houszero(x) 
%HOUSZERO Zeros in a vector using a Householder matrix. 
%[u,sigma] = houszero(x)  produces a vector u
%defining a Householder matrix H, and a scalar sigma
%such that Hx = [sigma, 0, ...., 0]'. 
%This program implements Algorithm 5.4.1 of the book.
%input  :  vector x
%output :  vector u, and scalar sigma

	[m,n] = size(x);
         mm = max(abs(x));
         x = x/mm;
         s = sign(x(1));
         if s == 0
          s = 1;
         end;
         sigma = s * norm(x,2);
         u = x + sigma * eye(m,1);
         sigma = -mm * sigma;
