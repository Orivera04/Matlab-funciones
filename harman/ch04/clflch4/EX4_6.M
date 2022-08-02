% EX4_6.M Verify results of Example 4.6
%  Compute eigenvalues and eigenvectors using eig
A=[1 -1 0;0 1 1;0 0 -2]
[V,D]=eig(A)		% V has eigenvectors as columns
%                          diag(D) are the eigenvalues
%
% Note that D has integer values so MATLAB is "perfect" in this case 
%   in determining eigenvalues
%
% Normalize columns of V to show that one eigenvector is [1 3 -9]'