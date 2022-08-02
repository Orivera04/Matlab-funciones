function [D,err,relerr,n] = diffext(f,x,delta,toler)
%---------------------------------------------------------------------------
%DIFFEXT   Numerical approximation for f'(x).
%          The method is Richardson`s extrapolation.
% Sample call
%   [D,err,relerr,n] = diffext('f',x,delta,toler)
% Inputs
%   f        name of the function
%   x        differentiation point
%   delta    error goal
%   toler    relative error goal
% Return
%   D        matrix of approximate derivatives
%   error    error bound
%   relerr   relative error bound
%   n        coordinate for D(n,n) "the best approximation for f'(x)"
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
% Algorithm 6.2 (Differentiation Using Extrapolation).
% Section	6.1, Approximating the Derivative, Page 327
%---------------------------------------------------------------------------

err = 1;
relerr = 1;
h = 1;
j = 1;
D(0+1,0+1) = (feval(f,x+h) - feval(f,x-h))/(2*h);
while relerr>toler & err>delta & j<12
  h = h/2;
  D(j+1,0+1) = (feval(f,x+h) - feval(f,x-h))/(2*h);
  for k = 1:j,
    D(j+1,k+1) = D(j+1,k-1+1) + (D(j+1,k-1+1)-D(j-1+1,k-1+1))/(4^k -1);
  end
  err = abs(D(j+1,j+1)-D(j-1+1,j-1+1));
  relerr = 2*err/(abs(D(j+1,j+1))+abs(D(j-1+1,j-1+1))+eps);
  j = j+1;
end
[n n] = size(D);
