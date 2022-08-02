function [P0,err,P] = fix2dim(G,P0,delta,max1)
%---------------------------------------------------------------------------
%FIX2DIM   Seidel fixed point iteration for higher dimensions.
% Sample calls
%   [P0,err] = fix2dim('G',P0,delta,max1)
%   [P0,err,P] = fix2dim('G',P0,delta,max1)
% Inputs
%   G       name of the vector function 
%   P0      starting vector
%   delta   convergence tolerance
%   max1    maximum number of iterations
% Return
%   P0      solution vector: the fixed point
%   err     error estimate for P0
%   P       History matrix of the iterations
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
% Algorithm 2.9* (Fixed Point Iteration in higher dimensions).
% Section	2.6, Iteration for Nonlinear Systems, Page 108
%---------------------------------------------------------------------------

P = P0;
for k=1:max1,
  P1 = feval(G,P0);
  P = [P;P1];
  err = norm(P1-P0);
  relerr = err/(norm(P1)+eps);
  P0 = P1;
  if (err<delta)|(relerr<delta), break, end
end
