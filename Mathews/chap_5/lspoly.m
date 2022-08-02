function C = lspoly(X,Y,m)
%---------------------------------------------------------------------------
%LSPOLY   Construct the least squares polynomial.
% Sample call
%   C = lspoly(X,Y)
% Inputs
%   X   vector of abscissas
%   Y   vector of ordinates
%   m   degree of the least squares polynomial
% Return
%   C   coefficient list for the least squares polynomial
%
% NUMERICAL METHODS: MATLAB Programs, (c) John H. Mathews 1995
% To accompany the text:
% NUMERICAL METHODS for Mathematics, Science and Engineering, 2nd Ed, 1992
% Prentice Hall, Englewood Cliffs, New Jersey, 07632, U.S.A.
% Prentice Hall, Inc.; USA, Canada, Mexico ISBN 0-13-624990-6
% Prentice Hall, International Editions:   ISBN 0-13-625047-5
% This free software is compliments of the author.
% E-mail address:      in%"mathews@fullerton.edu"
%
% Algorithm 5.2 (Least Squares Polynomial).
% Section	5.2, Curve Fitting, Page 278
%---------------------------------------------------------------------------

n = length(X);
B = zeros(1:m+1);
F = zeros(n,m+1);
for k=1:m+1,          % Powers of Xk are in columns of F.
  F(:,k) = X'.^(k-1);
end
A = F'*F;             % Compute the matrix A.
B = F'*Y';            % Compute the column vector B.
C = A\B;              % Solve the linear system A*C=B for C.
C = flipud(C);
