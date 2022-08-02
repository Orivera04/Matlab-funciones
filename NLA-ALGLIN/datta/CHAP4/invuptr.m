function T = invuptr(T);
%INVUPTR Inverse of an upper triangular matrix 
%T = invuptr(T) computes the inverse of a nonsingular upper triangular
%matrix T.  The output matrix T contains the inverse of T. 
%This program implements Algorithm 4.2.2 of the book.
%Input  : Matrix T 
%output : Matrix T

	[m,n] = size(T);
        if m~=n
        	disp('matrix T  is not square')  
        return;
        end;
        s = eye(n,n);
	for k = n:-1:1
          if ( T(k,k) == 0)   
            disp('matrix T is singular')
            return;    
          end;
	  T(k,k) = 1/T(k,k);
	  for i = k-1 :-1 :1
	    sum = 0;
	    sum = sum + T(i,i+1:k)*T(i+1:k,k);
	    T(i,k) = -sum/T(i,i);
	  end;
	end;  	
