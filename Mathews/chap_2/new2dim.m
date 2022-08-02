function [P0,Y0,err,P] = new2dim(F,J,P0,delta,epsilon,max1)
%---------------------------------------------------------------------------
%NEW2DIM   Newton's iteration for higher dimensions.
% Sample calls
%   [P0,F0,err] = new2dim('F','J',P0,delta,epsilon,max1)
%   [P0,F0,err,P] = new2dim('F','J',P0,delta,epsilon,max1)
% Inputs
%   F         name of the vector function
%   J         name of the Jacobian matrix
%   P0        starting vector
%   delta     convergence tolerance for P0
%   epsilon   convergence tolerance for Y0
%   max1      maximum number of iterations
% Return
%   P0        solution: the vector P0
%   Y0        solution: the function vector Y0
%   err       error estimate in the solution vector P0
%   P         History matrix of the iterations
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
% Algorithm 2.10 (Newton-Raphson Method in 2-Dimensions).
% Section	2.7,  Newton's Method for Systems, Page 116
%---------------------------------------------------------------------------

P = P0;
Y0 = feval(F,P0);
for k=1:max1,
  dF = feval(J,P0);
  if det(dF) == 0,
    dP = [0 0];
  else
    dP = (dF\Y0)';
  end
  P1 = P0 - dP;
  Y1 = feval(F,P1);
  err = norm(dP);
  relerr = err/(norm(P1)+eps);
  P0 = P1;
  Y0 = Y1;
  P = [P;P1];
  if (err<delta)|(relerr<delta)|(abs(Y1)<epsilon), break, end
end
Y0 = Y0';
