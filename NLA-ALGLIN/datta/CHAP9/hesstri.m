function  [A,B] = hesstri(A,B)
%HESSTRI Hessenberg-Triangular Reduction
% [A,B] = hesstri(A,B) overwrites
%A with and upper hessenberg matrix by orthogonal transformations
%and B with an upper triangular matrix by orthogonal transformations.
%see Section 9.3.1 of the book
%input  : Matrices A and B
%output : Matrices A and B

        
	[m,n] = size(A);
        Q = eye(n,n);
        Z = eye(n,n);
        [U,R] = qr(B);
         B = R;
         A = U'*A;
        for j = 1:n-2
         for i = n:-1:j+2
            x = zeros(2,1);
            x(1) = A(i-1,j);
            x(2) = A(i,j);
            [c,s] = givzero(x) ;
            A1 = c * A(i-1,:) + s*A(i,:);
            A2 = -s * A(i-1,:) + c*A(i,:);
            A(i-1,:) = A1;
            A(i,:) = A2;
            B1 = c * B(i-1,:) + s*B(i,:);
            B2 = -s * B(i-1,:) + c*B(i,:);
            B(i-1,:) = B1;
            B(i,:) = B2;
            x = zeros(2,1);
            x(1) = B(i,i-1);
            x(2) = B(i,i);
            [c,s] = givzero(x);
            B4 = c * B(:,i-1) + s*B(:,i);
            B3 = -s * B(:,i-1) + c *B(:,i);
            B(:,i-1) = B3;
            B(:,i) = B4;
            A4 = c * A(:,i-1) + s*A(:,i);
            A3 = -s * A(:,i-1) + c *A(:,i);
            A(:,i-1) = A3;
            A(:,i) = A4;
        end;
       end;
