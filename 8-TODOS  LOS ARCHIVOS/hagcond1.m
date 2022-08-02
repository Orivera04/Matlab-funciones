function [cnd,iter] = hagcond1(A);
%HAGCOND1 Hager's norm-1 condition number estimator
%[CND,ITER] = hagcond1(A) produces CND, the norm-1 condition number estimate
%using Hager's Algorithm. Integer iter is the number of
%iterations needed for the algorithm to converge.   
%This program calls the MATCOM programs BACKSUB and PARPIV.
%The program implements Algorithm 6.7.1 of the book.
%input  : Matrix A
%output : Scalar cnd and integer iter

	[m,n] = size(A);
        if m~=n
        	disp('matrix A  is not square')  ;
        	return;
        end;
	rho = 0;
        b = zeros(n,1);
        y = zeros(n,1);
	for i = 1 : n
	    b(i) = 1/n;
        end;
        flag = 0;
         iter = 0;
        count = 0;
        while flag == 0 
%solve Ax = b using parpiv
         [storea,U,M] = parpiv(A);
         bprime = M*b;
         x = backsub(U,bprime) ;
           if norm(x,1) <=  rho
            flag = 1;
             return;
           end;
         iter =  iter + 1;
         rho = norm(x,1);
	for i = 1:n
	  if x(i) >= 0
	    y(i) = 1;
	  else
	    y(i) = -1;
	  end;
	end;
%Solve A'z = y using parpiv
       c1 = A';
       [storea,U,M] = parpiv(c1);
       bprime = M * y;
       z = backsub(U,bprime);
      [j] = absmax(z);
        if abs(z(j)) > z'*b
          b = zeros(n,1);
          b(j) = 1;
	else
          flag = 1;
        end; 
       cnd = rho * norm(A,1);
       end; 
       end;

