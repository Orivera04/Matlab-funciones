function [C,L] = lagran(X,Y)
%---------------------------------------------------------------------------
%LAGRAN   Construction of the collocation polynomial.
%         The method is Lagrange interpolation.
% Sample calls
%   [C] = lagran(X,Y)
%   [C,L] = lagran(X,Y)
% Inputs
%   X   vector of abscissas
%   Y   vector of ordinates
% Return
%   W   coefficient list for the Lagrange polynomial
%   L   matrix for the Lagrange coefficient polynomials
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
% Algorithm 4.3 (Lagrange Approximation).
% Section	4.3, Lagrange Approximation, Page 224
%---------------------------------------------------------------------------

n1 = length(X);
n  = n1-1;
L = zeros(n1,n1);
for k=1:n+1,          % Form the Lagrange coefficient polynomials 
  V = 1;              % by using poly(r1) to create a polynomial
  for j=1:n+1,        % with a known root, and conv(P2,P1)
    if k ~= j,        % which is polynomial multiplication.
      V = conv(V,poly(X(j)))/(X(k)-X(j));
    end
  end
  L(k,:) = V;
end
C = Y*L; 
