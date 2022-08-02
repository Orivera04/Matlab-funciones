function [x,res_norm,iter,flag,hist,histt]=symmlq(A,b,tol,max_it,x,varargin);

% symmlq.m solves the linear system Ax=b using the
% SYMMLQ Method without preconditioning.
%
% input   A        REAL symmetric matrix
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
   x = zeros(length(b),1);
end

  q_tilde = b - A*x;
  n=length(A);
  beta = norm(q_tilde);
  q = q_tilde / beta;
  init_res = beta;
  c = -1; s = 0; c_old = 1; s_old = 0; gamma = 1;
  zeta = -1; zeta_old = 0;
  q_old = zeros(n,1);
  w = zeros(n,1);
  hist(1)=1;
  histt(1)=1;
  for iter = 1:max_it
    q_tilde = A*q;
    alpha = q'*q_tilde;
    q_tilde = q_tilde - alpha*q - beta*q_old;
    beta_old = beta;
    beta = norm(q_tilde);
    q_old = q;
    gamma_hat = -c*alpha - c_old*s*beta_old;
    gamma = sqrt(gamma_hat^2 + beta^2);
    delta = s*alpha - c_old*c*beta_old;
    eps = s_old*beta_old;
    c_old = c; s_old = s;
    c = gamma_hat/gamma;
    s = beta/gamma;
    w = s_old*w - c_old*q;
    zeta_oold = zeta_old; zeta_old = zeta;
    zeta = -(eps*zeta_oold + delta*zeta) / gamma;
    q = q_tilde / beta;
    x = x + zeta*(c*w + s*q);
    res_red = norm(b - A*(x + zeta*w / c)) / init_res
    hist(iter+1)=res_red;
    histt(iter+1)=norm(b-A*x)/init_res;
    if (res_red < tol), break, end                   % converged
    end
  res_norm = res_red * init_res;
  if (res_red < tol)
    flag = 0;
  else
    flag = 1;end
