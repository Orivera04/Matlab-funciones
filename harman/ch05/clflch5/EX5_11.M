% EX5_11.M  Test of Example 5.11
%  Eigenvectors (eigvec) and eigenvalues (eigval) for the
%   identity matrices (3 x 3)
n=3;Itest=eye(n)           % Vary n to test other sizes
[eigvec,eigval]=eig(Itest) 