function x = lsfrqrh(A,b);
%LSFRQRH Least Squares solutions using Householder QR
%x = lsfrqrh(A,b) computes the least squares solution x  to the full
%rank overdetermined system Ax = b using the Householder-Golub method.
%This program calls the MATCOM programs BACKSUB, HOUSZERO and PHOUSMUL.
%This program implements Algorithm 7.8.2 of the book.
%input  : Matrix A and vector b
%output : vector x

        [m,n] = size(A);
        y = zeros(n,1);
        s= min(n,m-1);
        for k = 1 : s
          [u,sigma] = houszero(A(k:m,k));
          A(k:m,k:n) = phousmul(A(k:m,k:n),u);
          b(k:m) = phousmul(b(k:m),u);
        end;
        r1 =  A;
        c = b;
        ran = rank(r1);
        R = r1(1:ran,:);
        x = backsub(R,c);
        end;
