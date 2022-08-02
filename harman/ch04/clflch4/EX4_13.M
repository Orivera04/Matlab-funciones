% EX4_13.M Compute A^5 by the polynomial equation for the
%  matrix A=[1 0 0;0 2 0;0 0 3] in Example 4.13
%    
A=[1 0 0;0 2 0;0 0 3]         % Test matrix
Eiga=eig(A)                   % Check the eigenvalues
Lampows=[1 1 1; 4 2 1;9 3 1]; % Matrix of eigenvalue powers 
flam=[1^5 2^5 3^5]';           % Powers of eigenvalues 
% Coefficients in matrix B
B=Lampows\flam;                % Coefficients of expansion
%
fprintf('Polynomial expansion of A^5=A5')
A5=B(1)*A^2 + B(2)*A + B(3)*eye(size(A)) 
% Check
A5chk=A^5
