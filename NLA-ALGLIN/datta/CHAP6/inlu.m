function T = inlu(A);
%INLU	Inverse using the LU factorization 
%T = inlu(A) computes the inverse T of A using LU factorization
%obtained by Gaussian elimination without pivoting.  
%input  : Matrix A
%output : Matrix T

	[m,n] = size(A);
        if m~=n
        	disp('matrix A  is not square')  ;
        	return;
        end;
        [L,U] = lu(A);
        T = inv(U) * inv(L);
        end;
