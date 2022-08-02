function [x,res_norm,iter,flag,hist]=tfqmr(A,b,tol,max_it,L,U,x,varargin);

% tfqmr.m solves the linear system Ax=b using the
% TFQMR Method without preconditioning.
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
%                          -1 : rho = 0 = rs'*w
%                          -2 : gamma = 0 = rs'*v
%         hist     REAL vector of residual reductions
%
% Heinrich Voss, 24.12.2000
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
   L = speye(length(A));
   U = L;
end

if nargin < 7
   x = zeros(length(b),1);
end

  r = U\(L\(b - A*x));
  dimension=length(A);
  rs = r;
%  rs=rand(dimension,1);
  w = r;
  u = r;
  v = U\(L\(A*u));
  d = zeros(dimension,1);
  tau = norm(r);
  init_res = tau;
  theta = 0;
  eta = 0;
  rho = rs'*r;
  if (rho == 0), break, end               % breakdown
  au0 = U\(L\(A*u));
  hist(1)=1;
  for iter = 1:max_it
    gamma = v'*rs;
    if (gamma == 0), break, end           % breakdown
    alpha1 = rho / gamma;
    alpha0 = alpha1;
    u0 = u;
    u = u - alpha0*v;
    w = w - alpha0*au0;
    d = u0 + (theta^2/alpha0)*eta*d;
    theta = norm(w)/tau;
    c = 1/sqrt(1+theta^2);
    tau = tau*theta*c;
    eta = c^2*alpha0;
    x = x + eta*d;
    au1 = U\(L\(A*u));
    w = w - alpha1*au1;
    d = u + (theta^2/alpha1)*eta*d;
    theta = norm(w) / tau;
    c = 1/sqrt(1+theta^2);
    tau = tau*theta*c;
    eta = c^2*alpha1;
    x = x + eta*d;
    res_red = norm(b - A*x) / init_res
    hist(iter+1)=res_red;
    if (res_red < tol), break, end        % converged
    beta = 1 / rho;
    rho = rs'*w;
    if (rho == 0), break, end             % breakdown
    beta = beta*rho;
    u = w + beta*u;
    au0 = U\(L\(A*u));
    v = au0 + beta*(au1 + beta*v);
    end
  res_norm = res_red * init_res;
  if (res_red < tol)
    flag = 0;
  elseif (rho == 0)
    flag = -1;
  elseif (gamma == 0)
    flag = -2
  else
    flag = 1;end
