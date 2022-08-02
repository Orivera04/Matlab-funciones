function [H] = shermor(A,u,v);
%SHERMOR  Sherman Morrison formula 
%H = shermor(A,u,v) computes the inverse of a matrix obtained
%by rank-one change in a matrix A, using the Sherman-Morrison
%formula : inv(A - uv').  u and v are column vectors.
%see section 6.5.2 of the book
%input  : Matrix A and vectors u and v
%output : Matrix H

	[m,n] = size(A);
        if m~=n
        	disp('matrix A  is not square')  
        	return;
        end;
	ainv = inv(A);
	alpha = 1/(1-v'*ainv*u);
	H = ainv + alpha*ainv*u*v'*ainv;
        end;
