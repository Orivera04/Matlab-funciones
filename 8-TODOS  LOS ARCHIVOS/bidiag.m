function  A = bidiag(A)
%BIDIAG  Reduction to bidiagonal form.
%B = bidiag(A)  reduces the matrix A to bidiagonal form. 
%This program calls the MATCOM programs HOUSZERO and PHOUSMUL.
%See Section 10.9 of the book.
%input  : Matrix A
%output : Matrix A

        
	[m,n] = size(A);
        B = A;
        for i = 1:n
          B = A(i:m,i:n);
	  [m1,n1] = size(B);
          x = B(1:m1,1);
          [u,sigma] = houszero(x);
          B = phousmul(B,u);
          if i <= (n-2)
            C = B(:,2:n1);
	    [m2,n2] = size(C);
            x = C(1,1:n2);
            x = x';
            [u,sigma] =  houszero(x);
            C = housmulp(C,u);
            B(:,2:n1) = C;
          end;
          A(i:m,i:n) =  B;
        end;
