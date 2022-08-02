function [x] = lsfrnme(A,b);
%LSFRNME Least-squares solution using normal equations 
%x = lsfrnme(A,b) computes the least squares solution x to the 
%full-rank overdetermined system Ax = b using the
%Normal equations. 
%This program calls the MATCOM programs CHOLES, FORELM and
%BACKSUB.
%This program implements Algorithm 7.8.1 of the book.
%input  : Matrix A and vector b
%output : vector x

	[m,n] = size(A);
        y = zeros(n,1);
	c = A'*b;
	HHtr = A'*A;
        [HHtr,H] = choles(HHtr);
        y = forelm(H,c)	;
        U = H';
	x = backsub(U,y);
        end;
