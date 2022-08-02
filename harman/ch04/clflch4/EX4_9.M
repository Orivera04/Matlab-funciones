% EX4_9.M Find eigenvalues and eigenvectors
%    for matrix A=[1 -1 0;0 1 1;0 0 -2]
%  The M-file corresponds to the session in Example 4.9
clear
A=[1 -1 0;0 1 1;0 0 -2]
EIG=eig(A)               % Determine eigenvalues
POLY=poly(A)             %  and characteristic polynomial
[V,D]=eig(A)             % V contains eigenvectors 
%                          diag(D) is eigenvalues
% % Take third column and set V(1,3)=1
V3=V(:,3)
v33=V3/V(1,3)
