function z = tp(A,B,t,m)
%---------------------------------------------------------------------------
%TP  Evaluates the trigonometric polynomial created with tpcoeff.
% Sample call
%   z = tp(A,B,t,m)
% Inputs
%   A   coefficient list for {cos(nx)}
%   B   coefficient list for {sin(nx)}
%   t   independent variable input value(s)
%   m   degree of the trigonomitric polynomial
% Return
%   z   function value(s)
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
% Algorithm 5.5 (Trigonometric Polynomials).
% Section	5.4, Fourier Series and Trigonometric Polynomials, Page 311
%---------------------------------------------------------------------------

z = A(1);
for j = 1:m,
  z = z + A(j+1)*cos(j*t) + B(j+1)*sin(j*t);
end

