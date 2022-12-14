function A = housmulp(A,u) 
%HOUSMULP Post Multiplication By a Householder Matrix
%A = housmulp(A,u) computes the post-multiplication of
%a matrix A by the Householder matrix H generated by a 
%vector u.  The output matrix A contains the product AH.
%See Section 5.4 of the book.
%input  : Matrix A and vector u
%output : Matrix A

	[m1,n] = size(A);
        beta = 2/(u'*u);
        for i = 1 : m1
          alpha = 0;
            alpha =  alpha + u(1:n) * A(i,1:n);
          alpha =  beta * alpha;
            A(i,1:n) = A(i,1:n) - (alpha*u(1:n))';
         end;
        end;

