function [p0,y0,err,P] = newton(f,df,p0,delta,epsilon,max1) 
%---------------------------------------------------------------------------
%NEWTON   Newton's method is used to locate a root.
% Sample calls
%   [p0,y0,err] = newton('f',df,p0,delta,epsilon,max1)
%   [p0,y0,err,P] = newton('f',df,p0,delta,epsilon,max1)
% Inputs
%   f         name of the function
%   df        name of the function's derivative input
%   p0        starting value
%   delta     convergence tolerance for p0
%   epsilon   convergence tolerance for y0
%   max1      maximum number of iterations
% Return
%   p0        solution: the root
%   y0        solution: the function value
%   err       error estimate in the solution p0
%   P         History vector of the iterations
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
% Algorithm 2.5 (Newton-Raphson Iteration).
% Section	2.4, Newton-Raphson and Secant Methods, Page 84
%---------------------------------------------------------------------------

P(1) = p0;
y0 = feval(f,p0);
for k=1:max1,
  df0 = feval(df,p0);
  if df0 == 0,
    dp = 0;
  else
    dp = y0/df0;
  end
  p1 = p0 - dp;
  y1 = feval(f,p1);
  err = abs(dp);
  relerr = err/(abs(p1)+eps);
  p0 = p1;
  y0 = y1;
  P = [P;p1];
  if (err<delta)|(relerr<delta)|(abs(y1)<epsilon), break, end
end
