function [R,quad,err,h] = romber(f,a,b,n,toler)
%---------------------------------------------------------------------------
%ROMBER   Quadrature using the Romberg integration.
% Sample call
%   [R,quad,err,h] = romber('f',a,b,n,toler)
% Inputs
%   f       name of the function
%   a       left  endpoint of [a,b]
%   b       right endpoint of [a,b]
%   n       maximum number of rows in the table
%   toler   convergence tolerance
% Return
%   R       Romberg table
%   quad    Romberg integration quadrature value
%   err     error estimate
%   h       smallest step size used
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
% Algorithm 7.4 (Romberg Integration).
% Section	7.3, Recursive Rules and Romberg Integration, Page 379
%---------------------------------------------------------------------------

m  = 1;
h  = b - a;
err = 1;
j = 0;
R = zeros(4,4);
R(1,1) = h*(feval(f,a) + feval(f,b))/2;
while ((err>toler)&(j<n))|(j<4)
  j = j+1;
  h = h/2;
  s = 0;
  for p = 1:m;
    x = a + h*(2*p-1);
    s = s + feval(f,x);
  end
  R(j+1,1) = R(j,1)/2 + h*s;
  m = 2*m;
  for k=1:j,
    R(j+1,k+1) = R(j+1,k) + (R(j+1,k)-R(j,k))/(4^k-1);
  end
  err = abs(R(j,j)-R(j+1,k+1));
end
quad = R(j+1,j+1);
