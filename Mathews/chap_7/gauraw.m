function [A,W] = gauraw
%---------------------------------------------------------------------------
%GAURAW   Subroutine to load the abscissas and weights
%         for Gaussian quadrature.
% Sample call
%   [A,W] = gauraw
% Inputs
%   There are no inputs for this function.
% Return
%   A   vector of abscissas for Gaussian quadrature
%   W   vector of  weights  for Gaussian quadrature
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
% Algorithm 7.6 (Gauss-Legendre Quadrature).
% Section	7.5, Gauss-Legendre Integration, Page 397
%---------------------------------------------------------------------------

load gauaw.dat;
A = zeros(17,48);
W = zeros(17,48);
c0 = 1;
for j = 1:17,
  m = j;
  i = j;
  if (j > 10),
    m = 12 + 4.*(j-11);
    i = fix(m);
  end
  if (j > 14),
    m = 24 + 8.*(j-14);
    i = fix(m);
  end
  for k = 1:fix((m+1)./2),
    A(j,k) = gauaw(c0);
    c0 = c0+1;
  end
  for k = 1:fix(m./2),
    A(j,i+1-k) = - A(j,k);
  end
  for k = 1:fix((m+1)./2),
    W(j,k) = gauaw(c0);
    c0 = c0+1;
  end
  for k = 1:fix(m./2),
    W(j,i+1-k) = W(j,k);
  end
end
% clear gauaw;
