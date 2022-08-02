function  [lambda,V] = invpow(A,alpha,X,epsilon,max1,show)
%---------------------------------------------------------------------------
%INVPOW   The inverse power method is used to find the dominant eigenpair.
% Sample call
%   [lambda,V] = invpow(A,alpha,X,epsilon,max1,show)
% Inputs
%   A         matrix
%   X         starting vector
%   alpha     given shift
%   epsilon   convergence tolerance
%   max1      maximum number of iterations
% Return
%   lambda    solution: dominant eigenvalue
%   V         solution: dominant eigenvector
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
% Algorithm 11.2 (Shifted Inverse Power Method).
% Section	11.2, The Power Method, Page 558
%---------------------------------------------------------------------------

if nargin==5, show = 0; end
[n n] = size(A);
A = A - alpha*eye(n);               % Form the matrix A - aIpha I
[A,row] = LUfact(A);
lambda = 0;
cnt = 0;
err = 1;
done = 0;
iterating = 1;
state = iterating;
while ((cnt<=max1)&(state==iterating))
  Y = LUsolv(A,X,row);
  [m j] = max(abs(Y));
  c1 = Y(j);                        % Find "largest" element of Y.
  dc = abs(lambda - c1);
  Y = (1/c1)*Y;                     % Perform scalar multiplication
  dv = norm(X-Y);
  err = max(dc,dv);
  X = Y;                            % Update vector  X
  lambda = c1;                      % Update scalar  lambda 
  state = done;
  if (err>epsilon),                 % Check for convergence
    state = iterating;
  end
  cnt = cnt+1;
  lamb = alpha + 1/c1;
  if show==1,
    home; if cnt==1, clc; end; 
    disp(['Inverse Power Method iteration No. ',int2str(cnt)]),...
    disp(''),disp('c1 = '),disp(c1),...
    disp('lambda = '),disp(lamb),...
    disp('Eigenvector = '),disp(X)
  end
end
lambda = alpha + 1/c1;
V = X;
