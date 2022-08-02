% P6_21.M M-File to solve an eigenvalue problem given the
%  number of intervals N and stepsize Delta x
N=input('Number of intervals N ');
DX=input('Delta x ');
% Form band matrix
y1=-1*ones(1,N-2);
A=2*eye(N-1)+diag(y1,1)+diag(y1,-1);
% Solve the eigenvalue equation A*y={[(DX)*lam]**2}*lam*y
Eigs=sqrt(eig(A)/(DX^2))
%
% Try N=10 and Delta x =pi/5
%