function [A,L,U] = lugsel(A) 
%LUGSEL LU factorization using Gaussian elimination without pivoting 
%[A,L,U] = lugsel(A) produces the LU factorization of a matrix A using 
%Gaussian elimination without pivoting : A = LU.  L is unit lower triangular
%and U is upper triangular.  This program implements
%Algorithm 5.2.1 of the book. The matrices L and U are
% also explicitly  formed. The upper triangular part of the
%matrix A contains the matrix U and the lower triangular
%part of the matrix A contains the multipliers.
%input  : Matrix A
%output : Matrices A, L and U 

	[m,n] = size(A);
        for k = 1 : n-1 
             if (A(k,k) == 0)
               disp('the algorithm has encountered a zero pivot')
               L=[];
               U=[];
               return;
              end;
             A(k+1:n,k) =  A(k+1:n,k)/ A(k,k);
             A(k+1:n,k+1:n)  = A(k+1:n,k+1:n)  - A(k+1:n,k) * A(k,k+1:n);
        end;
        U = triu(A);
        L =  tril(A,-1);
        for i = 1:n
        L(i,i) = 1;
        end;
        end;

