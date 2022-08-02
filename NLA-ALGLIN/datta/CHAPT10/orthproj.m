function  [R,N,OR,ON] = orthproj(A)
%ORTHPROJ Orthogonal projections using the SVD.
%[R,N,OR,ON]  = orthproj(A) computes the orthogonal projections
%once the orthonormal bases for the range R(A) and the null-space
%N(A) of A are obtained, using the SVD of a : [ U, S, V] = SVD(A).
%R is the projection onto R(A) = U1 * U1'
%N is the projection onto N(A) = V2 * V2'
%OR is the projection onto the orthogonal complement of R(A) = U2 * U2'
%ON is the projection onto the orthogonal complement of N(A) = V1 * V1'
%see section 10.6.2 of the book
%input  : Matrix A
%output : Matrices R, N, OR and ON
        
	[U,S,V] = svd(A);
        [m,n] = size(A);
        r = 0;
        for i = 1:n
         if S(i,i) > 10^(-15)
          r = r + 1;
         else
          i = n;
         end;
        end;
        U1 = U(:,1:r);
        U2 = U(:,r+1:n);
        V1 = V(:,1:r);
        V2 = V(:,r+1:n);
	R = U1 * U1';
        N = V2 * V2';
        OR = U2 * U2';
        ON = V1 * V1';
