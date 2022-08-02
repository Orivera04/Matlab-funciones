function U = forwdif(f,g1,g2,a,b,c,n,m)
%---------------------------------------------------------------------------
%FORWDIF   Finite difference solution to the heat equation.
% Sample call
%   U = forwdif('f','g1','g2',a,b,c,n,m)
% Inputs
%   f    name of a boundary function
%   g1   name of a boundary function
%   g2   name of a boundary function
%   a    width of interval [0 a]: 0<=x<=a
%   b    width of interval [0 b]: 0<=t<=b
%   c    constant in the heat equation
%   n    number of grid points over [0 a]
%   m    number of grid points over [0 b]
% Return
%   U    solution: matrix, output.
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
% Algorithm 10.2 (Forward-Difference Method for the Heat Equation).
% Section	10.2, Parabolic Equations, Page 516
%---------------------------------------------------------------------------

h = a/(n-1);
k = b/(m-1);
r = c^2*k/h^2;
s = 1 - 2*r;
U = zeros(n,m);
for j = 1:m,
 	U(1,j) = feval(g1,k*(j-1));
	 U(n,j) = feval(g2,k*(j-1));
end
for i = 2:(n-1),
	 U(i,1) = feval(f,h*(i-1));
end
for j = 2:m,
  for i = 2:(n-1),
	   U(i,j) = s*U(i,j-1) + r*(U(i-1,j-1) + U(i+1,j-1));
  end
end
