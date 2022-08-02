function [c,yc,err,P] = bisect(f,a,b,delta)
%---------------------------------------------------------------------------
%BISECT   The bisection method is used to locate a root.
% Sample calls
%   [c,yc,err] = bisect('f',a,b,delta)
%   [c,yc,err,P] = bisect('f',a,b,delta)
% Inputs
%   f       name of the function
%   a       left endpoint
%   b       right endpoint
%   delta   convergence tolerance
% Return
%   c       solution: the root
%   yc      solution: the function value
%   err     error estimate in c
%   P       History vector of the iterations
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
% Algorithm 2.2 (Bisection Method).
% Section	2.2, Bracketing Methods for Locating a Root, Page 61
%---------------------------------------------------------------------------

P = [a b];
ya = feval(f,a);
yb = feval(f,b);
if ya*yb > 0, break, end
max1 = 1 + round((log(b-a)-log(delta))/log(2));
for k=1:max1,
  c  = (a+b)/2;
  yc = feval(f,c);
  if  yc == 0,
    a = c;
    b = c;
  elseif  yb*yc > 0,
    b = c;
    yb = yc;
  else
    a = c;
    ya = yc;
  end
  P = [P;a b];
  if b-a < delta, break, end
end
c  = (a+b)/2;
yc = feval(f,c);
err = abs(b-a)/2;
