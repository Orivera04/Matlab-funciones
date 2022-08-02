% EX4_4.M  Check results of Example 4.4
%  Uses command eig to find eigenvalues and eigenvectors
format rat       % Rational fractions
R=[2 1;1 2]      % Define resistance matrix
G=inv(R)         % Find conductivity matrix
[V,D]=eig(G)     % Determine eigenvectors (V) and
%                    eigenvalues (diag(D))
fprintf('Eigenvectors are columns of V- normalized')
%
