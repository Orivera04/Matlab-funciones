function A = qritrh(A,numitr)
%QRITRH Hessenberg-QR iteration 
%A = qritrh(A,numitr) returns a reduced Hessenberg matrix starting 
%from a given upper Hessenberg matrix A using QR iterations.
%Givens rotations are used to factor A(k) into Q(k)R(k) .
%numitr is the user supplied number of iterations. 
%See Section 8.9.2 of the book.
%input  : Matrix A and integer numitr
%output : Matrix A

	[m,n] = size(A);
        if m~=n
        	disp('matrix A  is not square')  ;
        	return;
        end;
        [Q,R] = givqr(A);
        for k = 1 : numitr
         A = R*Q;
         [Q,R] = qr(A);
        end;
        end;
