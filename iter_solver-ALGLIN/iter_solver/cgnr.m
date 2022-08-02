function [x,res_norm,iter,flag,hist]=cgnr(A,b,tol,max_it,x,varargin);

% cgnr.m solves the linear system Ax=b using the
% CGNR Method without preconditioning.
%
% input   A        REAL matrix
%         x        REAL initial guess vector
%         b        REAL right hand side vector
%         max_it   INTEGER maximum number of iterations
%         tol      REAL desired reduction of residual norm
%
% output  x        REAL solution vector
%         res_norm REAL residual norm
%         iter     INTEGER number of iterations performed
%         flag     INTEGER: 0 : solution found to tolerance
%                           1 : no convergence given max_it
%         hist     REAL vector of residal reductions
%
% Heinrich Voss, 21.12.2000
%

if nargin < 2
   error('Not enough input arguments.');
end

if nargin < 3
   tol=1e-6;
end

if nargin < 4
   max_it=500;
end

if nargin < 5
   x = zeros(length(b),1);
end


  r = b - A*x;
  init_res = norm(r);               %initial residual norm
  d = A'*r;
  alpha = d'*d;
  hist(1)=1;
  for iter = 1:max_it                   % begin iteration
    s = A*d;
    tau = alpha / (s'*s);
    x = x + tau*d;
    r = r - tau*s;
    res_red = norm(r) / init_res
    hist(iter+1)=res_red;
    if (res_red < tol), break, end      % converged

    beta = 1 / alpha;
    s = A'*r;
    alpha = s'*s;
    beta = beta*alpha;
    d = s + beta*d;
    end
  res_norm = norm(r);
  if (res_red < tol)
    flag = 0;
  else
    flag = 1;end
