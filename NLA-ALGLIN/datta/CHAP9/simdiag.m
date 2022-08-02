function  X = simdiag(A,B)
%SIMDIAG Simultaneous diagonalization of a symmetric definite pencil
%X = simdiag(A,B) computes a nonsingular matrix X such that 
%X'BX is the identity matrix and X'AX is a diagonal matrix.
%Matrices A and B are symmetric and B is positive definite.
%This program implements Algorithm 9.5.3 of the book.
%input  : Matrices A and B
%output : Matrix X
        
	[m,n] = size(A);
	[C,L] = choles(B);
        Linv = inv(L);
        C = Linv * A * Linv';
	[Y,d] = eig(C);
        X = Linv' * Y;
