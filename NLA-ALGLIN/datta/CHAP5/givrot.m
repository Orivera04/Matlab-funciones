function J = givrot(i,j,c,s,n)
%GIVROT	Givens rotation matrix from Givens paramters c and s.
%J = givrot(i,j,c,s,n) forms the n x n Givens rotation matrix J
%from the Givens paramters c and s.  A(i,i) = c, A(i,j) = s,
%A(j,i) = -s, A(j,j) = c.  The other entries of J are the
%same as those of an n x n Identity matrix.
%input  : Integers i, j, n and scalars c and s 
%output : Matrix J


        J = eye(n,n);
        J(i,i) = c;
        J(i,j) = s;
        J(j,i) =-s ;
        J(j,j) = c;
