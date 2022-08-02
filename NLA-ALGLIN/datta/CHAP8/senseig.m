function s = senseig(A) 
%SENSEIG Reciprocal of the condition numbers of eigenvalues 
%s = senseig(A) computes a vector s containing the reciprocals 
%of the condition numbers of the eigenvalues of a diagonalizable matrix A.  
%See Section 8.7.2 of the book.  
%input  : Matrix A
%output : vector s

	[m,n] = size(A);
        if m~=n
        	disp('matrix A  is not square')  ;
        	return;
        end;
        e = eye(n,n) ;
        [X,d] = eig(A);
        invX = inv(X);
        for i = 1 :  n
         x =  (X(:,i))/norm(X(:,i)) ;
         invXtr=invX'; y = invXtr(:,i)/norm(invXtr(:,i));
         s(i) = abs(y' * x);
        end;
        end;
