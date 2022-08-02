% EX4_15.M  Compute the modal matrix for a matrix
%  
% INPUT:  Matrix A
% OUTPUT: Display of modal matrix, diagonalized matrix Adiag, 
%           expAdiag=exp(Adiag), and expA=exp(A) 
%  Calls function clmodal
%
A=input('Input the matrix A= ')   % Define the matrix
[M,Adiag]=clmodal(A);             % Compute the matrices
fprintf('Modal matrix and diagonalized matrix \n')
M                                 % Display Modal matrix
Adiag                             % Diagonalized matrix
fprintf('Press a key to continue \n')
pause
fprintf('Display of exp(Adiag) and exp(A) \n')
Minv=inv(M);	      % M^-1			
Adiag=Minv*A*M;       %  Form modal equation
expAdiag=expm(Adiag)  %  Display exp(Adiag)
expA=M*expAdiag*Minv  %  Display exp(A)
%
% Note: there are simpler ways to do some of the statements
%    improve the program  
