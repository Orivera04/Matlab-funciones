function [x,res_norm,iter,flag,hist]=cgs_lp(A,b,tol,max_it,L,U,x,varargin);

% cgs.m solves the linear system Ax=b using the
% CGS Method with left preconditioning (LU)^{-1}Ax=(LU)^{-1}b.
%
% input   A        REAL matrix
%         L        REAL lower triangular matrix
%         U        REAL upper triangular matrix
%         x        REAL initial guess vector
%         b        REAL right hand side vector
%         max_it   INTEGER maximum number of iterations
%         tol      REAL desired reduction of residual norm
%
% output  x        REAL solution vector
%         res_norm REAL residual norm
%         iter     INTEGER number of iterations performed
%         flag     INTEGER: 0: solution found to tolerance
%                           1: no convergence given max_it
%                      breakdown
%                          -1 : alpha = 0 = rs'*r
%                          -2 : gamma = 0 = rs'*A*d
%         hist     REAL vector of residual reductions
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
   L=speye(length(A));
   U=L;
end

if nargin < 7
   x = zeros(length(b),1);
end

  r = U\(L\(b - A*x));
  rs = r;
  alpha = rs'*r;
  init_res = sqrt(alpha);
  d = r;
  u = r;
  hist(1)=1;
  for iter = 1:max_it
    s = U\(L\(A*d));
    gamma = rs'*s;
    if (gamma == 0), break, end         % breakdown

    tau = alpha / gamma;
    q = u - tau*s;
    w = u + q;
    x = x + tau*w;
    r = r - tau*(U\(L\(A*w)));                    % residuum updated
%   r = b - A*x;                        % resiuum exact
    res_red = norm(r) / init_res
    hist(iter+1)=res_red;
    if (res_red < tol), break, end      % converged

    beta = 1/alpha;
    alpha = rs'*r;
    if (alpha == 0), break, end         % breakdown

    beta = alpha*beta;
    u = r + beta*q;
    d = u + beta*(q + beta*d);
    end;
  res_norm = b - A*x;
  if (res_red < tol)
    flag = 0;
  elseif (alpha == 0)
    flag = -1;
  elseif (gamma == 0)
    flag = -2
  else
    flag = 1;end
