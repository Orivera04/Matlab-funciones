function [x] =  mnudnme(A,b)
%MNUDNME Minimum-norm solution for the underdetermined system using normal 
%equations  x =  mnudnme(A,b) computes the minimum norm solution x to the full
%rank underdetermined system Ax = b using normal equations.  This
%program implements Algorthim 7.9.1 of the book.
%input  : Matrix A and vector b
%output : vector x

         y = (A*A') \ b;
         x = A'*y;
