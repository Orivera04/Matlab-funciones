function T = incompiv(A);
%INCOMPIV Inverse by complete pivoting 
%T = incompiv(A) computes the inverse of a matrix A using complete
%pivoting : inv(A) = Q*inv(U)*M.  
%input  : Matrix A
%output : Matrix T

	[m,n] = size(A);
        if m~=n
        	disp('matrix A  is not square')  ;
        	return;
        end;
	[C,U,M,Q] = compiv(A);
	T =  Q * (inv(U)) * M;
        end;
