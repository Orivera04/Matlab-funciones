function [x] =  mnudqrh(A,b)
%MNUDQRH Minimum-norm solution  for the underdetermined problem using QR  
%x = mnudqrh(A,b) computes the minimum norm solution x to the full rank
%underdetermined system Ax = b using the Householder QR factorization of A
%This program implements Algortihm 7.9.2 of the book.
%input  : Matrix A and vector b
%output : vector x

        [Q,R] = qr(A');
        ran = rank(R);
	Q1 = Q(:,1:ran);
        R1 = R(1:ran,:);
        yr = R1'\b;
        x = Q1*yr;
