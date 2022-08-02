function [x,res_norm,iter,flag,hist]=gmresm_lp(A,b,m,tol,max_it,L,U,x,varargin);

% gmresm.m solves the linear system Ax=b using the
% restarted GMRES Method without preconditioning.
%
% input   A        REAL matrix
%         x        REAL initial guess vector
%         b        REAL right hand side vector
%         max_it   INTEGER maximum number of cycles
%         tol      REAL desired reduction of residual norm
%         m        Integer restart after m steps of GMRES
%
% output  x        REAL solution vector
%         res_norm REAL residual norm
%         iter     INTEGER number of iterations performed
%         flag     INTEGER: 0: solution found to tolerance
%                           1: no convergence given max_it
%                      breakdown
%                          -1 : alpha = 0
%                          -2 : gamma = 0
%         hist     Real vector of residual reductions
%
% Heinrich Voss, 21.12.2000
%

if nargin < 3
   error('Not enough input arguments.');
end

if nargin < 4
   tol=1e-6;
end

if nargin < 5
   max_it=50;
end

if nargin < 6
   L=speye(length(b));
   U=L;
end

if nargin < 8
   x = zeros(length(b),1);
end

  q(:,1) = U\(L\(b - A*x));
  z(1) = norm(q(:,1));
  init_res = z(1);                      %initial residual norm
  q(:,1) = q(:,1) / z(1);
  hist(1)=1;
  for iter = 1:max_it                   % begin iteration
    for k = 1:m
      q(:,k+1) = U\(L\(A*q(:,k)));
      for i = 1:k
        h(i,k) = q(:,i)'*q(:,k+1);
        q(:,k+1) = q(:,k+1)-h(i,k)*q(:,i);
        end
      h(k+1,k) = norm(q(:,k+1));
      q(:,k+1) = q(:,k+1) / h(k+1,k);
      for i = 1:k-1
        he = c(i+1)*h(i,k) + s(i+1)*h(i+1,k);
        h(i+1,k) = s(i+1)*h(i,k) - c(i+1)*h(i+1,k);
        h(i,k) = he;
        end
      alpha = sqrt(h(k,k)^2 + h(k+1,k)^2);
      s(k+1) = h(k+1,k) / alpha;
      c(k+1) = h(k,k) / alpha;
      h(k,k) = alpha;
      z(k+1) = s(k+1)*z(k);
      z(k) = c(k+1)*z(k);
      res_red = abs(z(k+1)) / init_res
      hist((iter-1)*m+k+1)=res_red;
      end
    y(m) = z(m)/h(m,m);
    for i = m-1:-1:1
      y(i) = z(i);
      for j = i+1:m
        y(i) = y(i) - y(j)*h(i,j);
        end
      y(i) = y(i) / h(i,i);
      end
    for i=1:m
      x=x + y(i)*q(:,i);
      end
    res_red = abs(z(m+1)) / init_res
    if (res_red < tol), break, end                          % converged

    q(:,1) = U\(L\(b - A*x));
    z(1) = norm(q(:,1));
    q(:,1) = q(:,1) / z(1);
    end

  res_norm = abs(z(m+1));
  if (res_red < tol)
    flag = 0;
  else
    flag = 1;end
