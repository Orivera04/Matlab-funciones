function [x,res_norm,iter,flag,hist]=cg_p(A,b,L,tol,max_it,x,varargin);

% cg_hv.m solves the linear system Ax=b using the
% CG Method with preconditioning.
%
% input   A        REAL matrix, symmetric, positive definite
%         L        REAL lower triangular matrix, approximate Cholesky factor of A
%         x        REAL initial guess vector
%         b        REAL right hand side vector
%         max_it   INTEGER maximum number of iterations
%        L' tol      REAL desired reduction of residual norm
%
% output  x        REAL solution vector
%         res_norm REAL residual norm
%         iter     INTEGER number of iterations performed
%         flag     INTEGER: 0: solution found to tolerance
%                           1: no convergence given max_it
%
% Heinrich Voss, 20.12.2000
%

if nargin < 2
   error('Not enough input arguments.');
end

if nargin < 3
   L = speye(length(A));
end

if nargin < 4
   tol=1e-6;
end

if nargin < 5
   max_it=500;
end

if nargin < 6
   x = zeros(length(b),1);
end


  r = b - A*x;
  d = L'\(L\r);
  alpha = r'*d;
  init_res = norm(r);
  hist(1)=1;
  for iter = 1:max_it
    s = A*d;
    gamma = d'*s;
    tau = alpha / gamma;
    x = x + tau*d;
    r = r - tau*s;
    res_red = norm(r) / init_res
    hist(iter+1)=res_red;
    if (res_red < tol), break, end      % converged
    beta = 1 / alpha;
    z = L'\(L\r);
    alpha = r'*z;
    beta = beta*alpha;
    d = z + beta*d;
    end
  res_norm = norm(r);
  if (res_red < tol)
    flag = 0;
  else
    flag = 1;end
