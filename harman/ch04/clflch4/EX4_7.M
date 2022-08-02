% EX4_7.M Verify results of Example 4.7
%   Computes determinant and trace of a matrix and compares to
%     product and sum of eigenvalues, respectively.
%
A=[1 -1 0;0 1 1;0 0 -2]   % Define the matrix
detA=det(A)               % Compute the determinant and
traceA=sum(diag(A))       %  Same as trace command
pause
%
% Test using eigenvalues 
%
fprintf(' Determinant and trace from eigenvalues \n')
Eig=eig(A)              % Column vector of eigenvalues 
prodeig=prod(Eig)
traceA1=sum(Eig)

%
%  Modify the script to compute the eigenvalues and 
%   trace of an arbitrary matrix either input during a session
%   or saved in a disk file
%