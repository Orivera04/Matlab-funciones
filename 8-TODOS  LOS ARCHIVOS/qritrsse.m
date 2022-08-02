function H = qritrsse(A,numitr)
%QRITRSSE Explicit single-shift QR iteration
%H = qritrsse(A,numitr) returns an upper Hessenberg matrix H, starting
%from an arbitrary matrix A, using single-shift explicit QR iteration.
%numitr is the user-supplied number of iterations.  See Section 8.9.4 of
%the book.
%input  : Matrix A and integer numitr
%output : Matrix H

	[m,n] = size(A);
        if m~=n
        	disp('matrix A  is not square')  ;
        	return;
        end;
        [H,PP] = givhess(A);
        for k = 0 : numitr
         Hnn = H(n,n);
         [Q,R] = qr(H - Hnn*eye(n,n));
         H = R * Q + Hnn*eye(n,n);
        end;
        end;
