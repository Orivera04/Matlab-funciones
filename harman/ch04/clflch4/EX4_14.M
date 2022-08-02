% EX4_14.M  Compute the modal matrix and exp(A) for
%  the matrix A=[4 1;3 2] as in Example 4.14
%
A=[4 1;3 2]          % Define the matrix
[M D]=eig(A)         % M contains eigenvectors
Minv=inv(M);	     % M^-1			
Adiag=Minv*A*M       %  Form modal equation
expAdiag=expm(Adiag)
expA=M*expAdiag*Minv
pause
%
% Check result of the example
%
fprintf('Check result  expA=expAch? \n')
e=exp(1);
expAch=(1/4)*[e+3*e^5 -e+e^5;-3*e+3*e^5 3*e+e^5]
%
%  Execute with echo on or add print statements to improve
%   the output display
%