function  [lambda,V] = power(A,X,epsilon,max1,show)
%---------------------------------------------------------------------------
%POWER   The power method is used to find the dominant eigenpair.
% Sample call
%   [lambda,V] = power(A,X,epsilon,max1,show)
% Inputs
%   A         matrix, input.
%   X         starting vector, input.
%   epsilon   convergence tolerance    is the tolerance, input.
%   max1      maximum number of iterations, input.
% Return
%   lambda    solution: dominant eigenvalue, output.
%   V         solution: dominant eigenvector, output.
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
% Algorithm 11.1 (Power Method).
% Section	11.2, The Power Method, Page 557
%---------------------------------------------------------------------------

if nargin==4, show = 0; end
lambda = 0;
cnt = 0;
err = 1;
done = 0;
iterating = 1;
state = iterating;
while ((cnt<=max1) & (state==iterating))
  Y = A*X;               % Matrix multiplication
  [m j] = max(abs(Y));
  c1 = Y(j);             % Find "largest" element of Y.
  dc = abs(lambda-c1);
   Y = (1/c1)*Y;         % Perform scalar multiplication
  dv = norm(X-Y);
  err = max(dc,dv);
  X = Y;                 % Update vector  X
  lambda = c1;           % Update scalar lambda
  state = done;
  if (err>epsilon),      % Check for convergence
    state = iterating;
  end
  cnt = cnt+1;
  if show==1,
    home; if cnt==1, clc; end; 
    disp(['Power Method iteration No. ',int2str(cnt)]),disp(''),...
    disp('lambda = '),disp(lambda),...
    disp('Eigenvector = '),disp(X)
  end
end
V = X;
