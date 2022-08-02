% EX5_8.M  Check the calculations of Example 5_8
%
A=[1 1;4 1]                  % Matrix for system
fprintf('Eigenvectors (U) and eigenvalues diag(D) \n')
[U,D]=eig(A)                 % U has eigenvectors, diag(D) is eigenvalues
fprintf(' U has eigenvectors, diag(D) is eigenvalues \n')
pause
% Solve for constants
x0=[1 1]'                    % Initial conditions
c=inv(U)*x0                  % Coefficients  [c1 c2]'
fprintf(' Coefficients of exp(3t) and exp(-t)\n')
format rat                    % Rational fractions
C=[c(1)*U(:,1) c(2)*U(:,2)]   % Coefficient vector  
format                        % Default
%
%  Note: The eigenvectors and coefficient for exp(-t) and exp(3t)
%    are reversed in the MATLAB solution
%
% Try the exponential matrix solution and compute the solution 
%   at values such as t=1
