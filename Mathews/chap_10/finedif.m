function U = finedif(f,g,a,b,c,n,m)
%---------------------------------------------------------------------------
%FINEDIF   Finite difference solution to the wave equation.
% Sample call
%   U = finedif('f','g',a,b,c,n,m)
% Inputs
%   f   name of a boundary function
%   g   name of a boundary function
%   a   is the width of interval [0 a]: 0<=x<=a
%   b   is the width of interval [0 b]: 0<=t<=b
%   c   is the constant in the wave equation
%   n   is the number of grid points over [0 a]
%   m   is the number of grid points over [0 b]
% Return
%   U   solution: matrix
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
% Algorithm 10.1 (Finite-Difference Solution for the Wave Equation).
% Section	10.1, Hyperbolic Equations, Page 507
%---------------------------------------------------------------------------

h = a/(n-1);
k = b/(m-1);
r = c*k/h;
r2 = r^2;
r22 = r^2/2;
s1 = 1 - r^2;
s2 = 2 - 2*r^2;
U = zeros(n,m);
for i=2:(n-1),
  U(i,1) = feval(f,h*(i-1));
  U(i,2) = s1*feval(f,h*(i-1)) + k*feval(g,h*(i-1)) ...
         + r22*(feval(f,h*(i)) + feval(f,h*(i-2)));
end
for j=3:m,
  for i=2:(n-1),
    U(i,j) = s2*U(i,j-1) + r2*(U(i-1,j-1) + U(i+1,j-1)) - U(i,j-2);
  end
end
