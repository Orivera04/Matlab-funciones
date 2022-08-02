function [p,yp,err,Q] = steff(f,df,p0,delta,epsilon,max1)
%---------------------------------------------------------------------------
%STEFF   Steffensen's method is used to locate a root.
% Sample calls
%   [p,yp,err] = steff('f',df,p0,delta,epsilon,max1)
%   [p,yp,err,Q] = steff('f',df,p0,delta,epsilon,max1)
% Inputs
%   f         name of the function
%   d         name of the function's derivative
%   p0        starting value
%   delta     convergence tolerance for p
%   epsilon   convergence tolerance for yp
%   max1      maximum number of iterations
% Return
%   p         solution: the root
%   yp        solution: the function value
%   err       error estimate in the solution p
%   Q         History vector of the iterations
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
% Algorithm 2.7 (Steffensen's Acceleration).
% Section	2.5, Aitken's Process & Steffensen's & Muller's Methods, Page 96
%---------------------------------------------------------------------------

y0 = feval(f,p0);
p = p0; yp = y0;
Q(1) = p0;
for k=1:max1,
  df0 = feval(df,p0);
  if df0 == 0,
    dp = 0;
  else
    dp = y0/df0;
  end
  p1 = p0 - dp;
  y1 = feval(f,p1);
  p = p1; yp = y1;
  Q = [Q,p1];
  err = abs(dp);
  relerr = err/(abs(p1)+eps);
  if (err<delta)|(relerr<delta)|(abs(y1)<epsilon), break, end
  df1 = feval(df,p1);
  if df1 == 0,
    dp = 0;
  else
    dp = y1/df1;
  end
  p2 = p1 - dp;
  y2 = feval(f,p2);
  p = p2; yp = y2;
  Q = [Q,p2];
  err = abs(dp);
  relerr = err/(abs(p1)+eps);
  if (err<delta)|(relerr<delta)|(abs(y1)<epsilon), break, end
  d1 = (p1 - p0)^2;
  d2 = p2 - 2*p1 + p0;
  if  d2 ==0, 
    dp = p2 - p1;
    p3 = p2;
    break;
  else
    dp = d1/d2;
    p3 = p0 - dp;
  end
  p0 = p3;
  y0 = feval(f,p0);
  p = p0; yp = y0;
  Q = [Q,p0];
  err = abs(dp);
  relerr = err/(abs(p3)+eps);
  if (err<delta)|(relerr<delta)|(abs(y1)<epsilon), break, end
end
