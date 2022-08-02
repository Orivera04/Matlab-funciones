function Ak = qritrb(A,numitr) 
%QRITRB	Basic QR iteration
%Ak = qritrb(A,numitr) returns the matrix Ak after 'numitr' number
%of basic QR iterations. numitr is a user specified integer.
%See Section 8.9.1 of the book. 
%input  : Matrix A and integer numitr
%output : Matrix Ak

	[m,n] = size(A);
        if m~=n
        	disp('matrix A  is not square')  ;
        	return;
        end;
        [Q,R] = qr(A);
        for k = 1 : numitr
         Anew = R*Q;
         [Q,R] = qr(Anew);
        end;
        Ak = Anew;
        end;
