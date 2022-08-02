function y = forelm(L,b);
%FORELM  Forward elimination
%y = forelm(L,b) computes the solution y of a nonsingular lower
%triangular system Ly = b using forward elimination process.
%This program implements Algorithm 6.4.1 of the book.
%Input  : Matrix L and vector b
%output : vector y 

	[m,n] = size(L);
        if m~=n
        	disp('matrix L  is not square')  
        	return;
        end;
        y = zeros(n,1);
        y(1) = b(1) / L(1,1);
        for i = 2:n
          sum =L(i,1:i-1)*y(1:i-1);
        if ( L(i,i) == 0)
          disp('matrix L is singular')
          return;
        end;
        y(i) = (b(i) - sum ) / L(i,i);
        end;
        end;
