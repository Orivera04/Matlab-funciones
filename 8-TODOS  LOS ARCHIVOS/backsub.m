function [y] = backsub(T,b);
%BACKSUB Back substitution 
%y = backsub(T,b) computes the solution y of a nonsingular upper
%triangular system Ty = b using back substitution process.
%This program implements Algorithm 3.1.3 of the book.  
%Input  : Matrix T and vector b
%output : vector y


	[m,n] = size(T);
        if m~=n
        	error('matrix T  is not square')
        end;
        y = zeros(n,1);
        for i = n:-1:1
          sum = 0;
	  if (i ~= n)
          	sum = T(i,i+1:n)*y(i+1:n);
	  end;
          if (T(i,i) ==0) 
             error('matrix T is singular')
          end;
          y(i) = (b(i) - sum ) / T(i,i);
        end;
