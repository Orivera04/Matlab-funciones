function [quad,errb,cnt] = aqustep(f,a,c,b,fa,fc,fb,sr0,tol,lev)
%---------------------------------------------------------------------------
%AQUSTEP   Recursive subroutine for Simpson`s adaptive quadrature.
% Sample call
%   [quad,errb,cnt] = aqustep('f',a,c,b,fa,fc,fb,sr0,tol,lev)
% Inputs
%   f      name of the function
%   a      left  endpoint of [a,b]
%   b      right endpoint of [a,b]
%   tol    convergence tolerance
% Return
%   quad   Recursive Simpson quadrature value
%   errb   error bound estimate
%   cnt    number of function evaluations
%   lev    level of recursion
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
% Algorithm 7.5a (Adaptive Quadrature Using Simpson's Rule).
% Section	7.4, Adaptive Quadrature, Page 389
%---------------------------------------------------------------------------

max1 = 10;
if lev > max1,
   disp('Beware, recursion level exceeded!');
   quad = sr0;
else
  h  = (b - a)/2;
  c1 = (a + c)/2;             % Determine midpoints c1 and c2 
  c2 = (c + b)/2;             % for  [a c]  and  [c b].
  f1 = feval(f,c1);           % Compute new function values
  f2 = feval(f,c2);           % f(c1)  and  f(c2).
  sr1 = h*(fa + 4*f1 + fc)/6; % Simpson's rule for [a,c].
  sr2 = h*(fc + 4*f2 + fb)/6; % Simpson's rule for [c,b].
  quad = sr1 + sr2;
  errb = abs(sr1 + sr2 - (h*(fa + 4*fc + fb)/3))/10;
  cnt = 2;
  err = abs(quad - sr0)/10;
  % Recursively refine the subintervals if necessary.
  if err > tol,
    tol2 = tol/2;
    [sr1,errb1,cnt1] = aqustep(f,a,c1,c,fa,f1,fc,sr1,tol2,lev+1);
    [sr2,errb2,cnt2] = aqustep(f,c,c2,b,fc,f2,fb,sr2,tol2,lev+1);
    quad = sr1 + sr2;
    errb = errb1 + errb2;
    cnt = cnt + cnt1 + cnt2;
  end
end
