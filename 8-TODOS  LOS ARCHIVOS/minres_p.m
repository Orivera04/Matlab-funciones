function [x,res_norm,iter,flag,hist]=minres_p(A,b,L,tol,max_it,x,varargin);

% minres_p.m solves the linear system Ax=b using the
% MINRES Method with preconditioning.
%
%
% input   A        REAL symmetric matrix (maybe indefinite)
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
% Heinrich Voss, 02.01.2001
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


  r0 = b - A*x;
  w=L'\(L\r0);
  beta = sqrt(w'*r0);
  q=r0/beta;
  w=w/beta;
  init_res = norm(r0);                                  %init. res. norm
  c = -1; s = 0; c_old = 1; s_old = 0;
  eta = beta;
  q_old = zeros(length(x),1);
  v_old = zeros(length(x),1);
  v_oold = zeros(length(x),1);
  hist(1)=1;
  for iter = 1:max_it                                   %begin iteration
    q_tilde = A*w-beta*q_old;
    alpha = w'*q_tilde;
    q_tilde = q_tilde - alpha*q;
    w_old=w;
    w=L'\(L\q_tilde);
    beta_old = beta;
    beta = sqrt(w'*q_tilde);
    gamma_tilde = -c*alpha - c_old*s*beta_old;
    gamma = sqrt(gamma_tilde^2 + beta^2);
    delta = s*alpha - c_old*c*beta_old;
    epsilon = s_old*beta_old;
    c_old = c; s_old = s;
    c = gamma_tilde / gamma;
    s = beta / gamma;
    v = (w_old - epsilon*v_oold - delta*v_old) / gamma;
    x = x + c*eta*v;
    v_oold = v_old;
    v_old = v;
    eta = s*eta;
    q_old = q;
    q=q_tilde/beta;
    w=w/beta;
    res_red = norm(b - A*x) / init_res
    hist(iter+1)=res_red;
    if (res_red < tol), break, end      % converged
    end
  res_norm = norm(b - A*x);
  if (res_red < tol)
    flag = 0;
  else
    flag = 1;end
