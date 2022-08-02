function [x,res_norm,iter,flag,hist]=qmr_lp(A,b,tol,max_it,L,U,x,varargin);

% qmr.m solves the linear system Ax=b using the
% QMR Method without preconditioning.
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
%         flag     INTEGER: 0 : solution found to tolerance
%                           1 : no convergence given max_it
%                      breakdown
%                          -1 : beta = 0 : serious breakdown
%         hist     REAL vector of residual reductions
%
% Heinrich Voss, 30.12.2000
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
   U=L;
end

if nargin < 7
   x = zeros(length(b),1);
end

  n=length(A);
  r = U\(L\(b - A*x));
  init_res = norm(r);
  v = r / init_res;
  w = v;
  z(1) = 1;
  beta_old = 0;
  gamma = 0;
  v_old = zeros(n,1);
  w_old = zeros(n,1);
  p_old = zeros(n,1);
  p_oold = zeros(n,1);
  s=0;c=1;
  hist(1)=1;
  for iter = 1:max_it                               % begin iteration
    v_tilde = U\(L\(A*v));
    w_tilde = A'*(L'\(U'\w));
    alpha=v_tilde'*w;
    v_tilde = v_tilde - alpha*v - beta_old*v_old;
    w_tilde = w_tilde - alpha*w - gamma*w_old;
    gamma = norm(v_tilde);
    if (gamma == 0), break, end                    % converged
    v_tilde = v_tilde / gamma;
    beta = v_tilde'*w_tilde;
    if (beta == 0), break, end                     % breakdown

    w_tilde = w_tilde / beta;
    if iter > 2
      rho=s_old*beta_old;
      xi=-c_old*beta_old;
    else
      xi=beta_old;
      rho=0;
      end
    if iter > 1
      he=c*xi+s*alpha;
      alpha=s*xi-c*alpha;
      xi=he;
      end
    no=sqrt(alpha^2+gamma^2);
    s_new=gamma/no;
    c_new=alpha/no;
    alpha=no;
    z(iter+1)=s_new*z(iter);
    z(iter)=c_new*z(iter);
    p=(v-xi*p_old-rho*p_oold)/alpha;
    x=x+init_res*z(iter)*p;
    s_old=s; c_old=c; s=s_new; c=c_new;
    p_oold=p_old; p_old=p;
    v_old=v; v=v_tilde; w_old=w; w=w_tilde;
    beta_old=beta;
    res_red = norm(A*x-b) / init_res
    hist(iter+1)=res_red;
    if (res_red < tol), break, end                          % converged
    end

  res_norm = norm(b-A*x);
  if (res_red < tol)
    flag = 0;
  elseif (beta == 0)
    flag = -1;
  else
    flag = 1;end
