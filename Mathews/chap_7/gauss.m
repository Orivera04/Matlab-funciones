function [Q,N,X,quad,err] = gauss(f,a,b,A,W,toler)
%---------------------------------------------------------------------------
%GAUSS   Gaussian quadraturequadrature.
% Sample call
%   [Q,N,X,quad,err] = gauss('f',a,b,A,W,toler)
% Inputs
%   f       name of the function
%   a       left  endpoint of [a,b]
%   b       right endpoint of [a,b]
%   A       table of abscissas
%   W       table of weights
%   toler   convergence tolerance
% Return
%   Q       table of Gaussian quadrature values
%   N       number of abscissas used
%   X       abscissas that were used
%   quad    Gaussian quadraturevalue
%   err     error estimate
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

mid  = (a+b)/2;
wide = (b-a)/2;
err  = 1;
j = 1;
x = mid + A(1,1);
N(1) = 1;
Q(1)= W(1,1)*feval(f,x)*wide;
while (((err>toler)|(j<4))&(j<17))
  j = j+1;
  sum1 = 0;
  i = j;
  if (j>10),
    i = 12 + 4*(j-11);
  end
  if (j>14),
    i = 24 + 8*(j-14);
  end
  for k = 1:i,
    X(k) = mid + A(j,k)*wide;
    sum1 = sum1 + W(j,k)*feval(f,X(k));
  end
  N(j) = i;
  Q(j) = sum1*wide;
  quad = Q(j);
  err = abs(Q(j)-Q(j-1));
end
