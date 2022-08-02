function [x,res_norm,iter,flag,hist]=qmrbcgst_lp(A,b,tol,max_it,L,U,x,varargin);

% qmrbcgst.m solves the linear system Ax=b using the
% QMRBCGStab Method without preconditioning.
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
%                          -1 : rho = 0 = r'*rs
%                          -2 : gamma = 0 = v'*rs
%         hist     REAL vector of residual reductions
%
% Heinrich Voss, 22.12.2000
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
  rs = r;
  u = r;
  v = U\(L\(A*u));
  tau = norm(r);
  init_res = tau;                                   %init. res. norm
  d = zeros(length(x),1);
  rho = rs'*r;
  if (rho == 0), break, end                         % breakdown
  theta = 0;
  eta = 0;
  hist(1)=1;
  for iter = 1:max_it                               % begin iteration
    gamma = v'*rs;
    if (gamma == 0), break, end                     % breakdown
    alpha = rho / gamma;
    s = r - alpha*v;
    theta_tilde = norm(s) / tau;
    c = 1 / sqrt(1+theta_tilde^2);
    d = u + (theta^2*eta/alpha)*d;
    eta = c^2*alpha;
    x = x + eta*d;
    tau = tau*theta_tilde*c;
    w = U\(L\(A*s));
    omega = (w'*s) / (w'*w);
    r = s - omega*w;
    theta = norm(r) / tau;
    c = 1 / sqrt(1 + theta^2);
    d = s + (theta_tilde^2/omega)*eta*d;
    eta = c^2*omega;
    x = x + eta*d;
    tau = tau*theta*c;
%    res_red = sqrt(2*iter+1)*tau / init_res
    res_red = norm(b-A*x) / init_res
    hist(iter+1)=res_red;
    if (res_red < tol), break, end                  % converged
    beta = 1 / rho;
    rho = rs'*r;
    if (rho == 0), break, end                       % breakdown
    beta = beta*rho*alpha/omega;
    u = r + beta*(u - omega*v);
    v = U\(L\(A*u));
    end
  res_norm = norm(b - A*x);
  if (res_red < tol)
    flag = 0;
  elseif (rho == 0)
    flag = -1;
  elseif (gamma == 0)
    flag = -2
  else
    flag = 1;end
