function NH = qritrdse(H,numitr)
%QRITRDSE Explicit double shift QR iteration 
%NH = qritrdse(H,numitr) returns an upper Hessenberg matrix NH, starting from 
%a given upper Hessenberg matrix H, using explicit double-shift QR
%iteration.  numitr is the number of iterations specified by the user.
%see section 8.9.5 of the book.  The matrix H is overwritten by
%itself after each iteration.
%input  : Matrix H and integer numitr
%output : matrix NH

	[m,n] = size(H);
        if m~=n
        	disp('matrix H  is not square')  ;
        	return;
        end;
        for k = 1 : numitr
        t = H(n-1,n-1) + H(n,n);
        d = H(n-1,n-1) * H(n,n) - H(n,n-1) * H(n-1,n);
         N = H*H - t*H + d*eye(n,n) ;
         [q,r] = qr(N);
         Hnew =  q'*H*q;
         H = Hnew;
        end;
        NH = H;
        end;
