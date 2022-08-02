function [p0,err,P] = fixpt(g,p0,tol,max1)
%---------------------------------------------------------------------------
%FIXPT   Fixed point iteration.
% Sample calls
%   [p0,err] = fixpt('g',p0,tol,max1)
%   [p0,err,P] = fixpt('g',p0,tol,max1)
% Return
%   g      name of the function
%   p0     starting value
%   tol    convergence tolerance
%   max1   maximum number of iterations
% Return
%   p0     solution: the fixed point
%   err    error estimate in the solution
%   P      History vector of the iterations
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
% Algorithm 2.1  (Fixed Point Iteration).
% Section	2.1,  Iteration for Solving  x = g(x), Page 51
%---------------------------------------------------------------------------

P(1) = p0;
err = 1;
relerr = 1;
p1 = p0;
for k=1:max1,
  p1 = feval(g,p0);
  err = abs(p1-p0);
  relerr = err/(abs(p1)+eps);
  if (err<tol) | (relerr<tol), break; end
  p0 = p1;
  P(k+1) = p1;
end

