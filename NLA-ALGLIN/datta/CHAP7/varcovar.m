function X = varcovar(A);
%VARCOVAR Variance-Covariance matrix 
%X = varcovar(A) computes the variance-covariance matrix X from A :
%X = inv(A' * A) explicitly without computing A'A. 
%This program implements Algorithm 7.11.1 of the book.
%input  : Matrix A
%output : matrix X

	[m,n] = size(A);
        [Q,R1] = qr(A);
        ran = rank(R1);
        R = R1(1:ran,:);
        X=zeros(n,n);
        ey = eye(n,n);
        e = ey(:,n) ;
        y = R\(e/R(n,n)) ;
        X(:,n) = y;
        X(n,:) =  y';
        for k = n-1 :-1:1
             sum = R(k,k+1:n)*X(k+1:n,k);
	   X(k,k) = ( 1/R(k,k) - sum )/(R(k,k));
           for i = k-1 :-1:1
            i;
            k;
               sum1 =  R(i,i+1:k) * X(i+1:k,k);
                sum2 =  R(i,k+1:n) * X(k,k+1:n)';
            X(i,k) = (sum1 + sum2)/(-R(i,i));
            X(k,i) = X(i,k);
           end;
        end;
        end;
