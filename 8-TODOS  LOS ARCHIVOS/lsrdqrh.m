 	function [x] =  lsrdqrh(A,b)
%LSRDQRH Least-squares solutions for the rank deficient problem using Householder QR
%x = lsrdqrh(A,b) computes a least-squares solution x
%to the rank - deficient overdetermined system Ax = b using
%Householder QR Factorization A.  
%This program calls the MATCOM program BACKSUB.
%This program implements Algorthim 7.8.6 of the book. 
%input  : Matrix A and vector b
%output : vector x

	[m,n] = size(A);
        ran = rank(A);
        y = zeros(n,1);
	[Q,R,p] = qr(A);
	z1 = Q'*b;
        c=z1(1:ran);
        R11=R(1:ran,1:ran);
        if ((ran+1) <= n)
          r12=R(1:ran,ran+1:n);
	  y2=rand(n-ran,1);
	  y(ran+1:n)=y2;
          z2 = c-r12*y2;
        else
          z2 = c;
        end
        y1 = backsub(R11,z2);
        y(1:ran)=y1;
	x=p*y;
        end;

