function [NH,Q] = qritrdsi(H)
%QRITRDSI One iteration step  of the Implicit Double Shift QR Iteration 
%[NH,Q] = qritrdsi(H) returns an upper Hessenberg matrix NH,
%starting from a given upper Hessenberg matrix H, using
%one step of implicit double shift QR iteration.  Q is the
%transforming orthogonal matrix : Q'HQ = NH. 
%This program calls the MATCOM program HOUSZERO.
%The program implements Algorithm 8.9.1 of the book.
%input  : Matrix H
%output : Matrix NH and Q

	[m,n] = size(H);
        if m~=n
        	disp('matrix H  is not square')  ;
        	return;
        end;
        Q = eye(n,n) ;
        t = H(n-1,n-1) + H(n,n);
        d = H(n-1,n-1) * H(n,n) - H(n,n-1) * H(n-1,n);
        x = H(1,1)*H(1,1)   - t* H(1,1) + d + H(1,2) * H(2,1);
        y = H(2,1) * (H(1,1) + H(2,2) -t);
        z = H(2,1) * H(3,2);
        for k = 0: n -3
         [u,sigma] = houszero([x y z]');
         c = eye(size(u), size(u)) - 2 * u * u' / (u' * u);
         Pk = eye(n,n);
         Pk(k+1:k+3,k+1:k+3) = c;
         Q = Q*Pk ;
         H = Pk'*H*Pk;
          x = H(k+2,k+1);
          y = H(k+3,k+1);
          if k < n-3
           z = H(k+4,k+1);
          end;
        end;
         [u,sigma] = houszero([x y ]');
         c = eye(size(u), size(u)) - 2 * u * u' / (u' * u);
         Pk = eye(n,n);
         Pk(n-1:n,n-1:n) = c;
         Q = Q*Pk;
         H = Pk'*H*Pk;
         NH = H;
        end;

