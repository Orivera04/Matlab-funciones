function [x, error, iter, flag] = cgs(A, x, b, M, max_it, tol)

%  -- Iterative template routine --
%     Univ. of Tennessee and Oak Ridge National Laboratory
%     October 1, 1993
%     Details of this algorithm are described in "Templates for the
%     Solution of Linear Systems: Building Blocks for Iterative
%     Methods", Barrett, Berry, Chan, Demmel, Donato, Dongarra,
%     Eijkhout, Pozo, Romine, and van der Vorst, SIAM Publications,
%     1993. (ftp netlib2.cs.utk.edu; cd linalg; get templates.ps).
%
%  [x, error, iter, flag] = cgs(A, x, b, M, max_it, tol)
%
% cgs.m solves the linear system Ax=b using the 
% Conjugate Gradient Squared Method with preconditioning.
%
% input   A        REAL matrix
%         x        REAL initial guess vector
%         b        REAL right hand side vector
%         M        REAL preconditioner
%         max_it   INTEGER maximum number of iterations
%         tol      REAL error tolerance
%
% output  x        REAL solution vector
%         error    REAL error norm
%         iter     INTEGER number of iterations performed
%         flag     INTEGER: 0 = solution found to tolerance
%                           1 = no convergence given max_it

  iter = 0;                               % initialization
  flag = 0;

  bnrm2 = norm( b );
  if  ( bnrm2 == 0.0 ), bnrm2 = 1.0; end

  r = b - A*x;
  error = norm( r ) / bnrm2;
  if ( error < tol ) return, end

  r_tld = r;

  for iter = 1:max_it,                    % begin iteration

     rho = (r_tld'*r );
     if (rho == 0.0), break, end

     if ( iter > 1 ),                     % direction vectors
        beta = rho / rho_1;
        u = r + beta*q;
        p = u + beta*( q + beta*p );
     else
        u = r;
        p = u;
     end

     p_hat = M \ p;
     v_hat = A*p_hat;                     % adjusting scalars
     alpha = rho / ( r_tld'*v_hat );
     q = u - alpha*v_hat;
     u_hat = M \ (u+q);

     x = x + alpha*u_hat;                 % update approximation

     r = r - alpha*A*u_hat;
     error = norm( r ) / bnrm2;           % check convergence
     if ( error <= tol ), break, end

     rho_1 = rho;

  end 

  if (error <= tol),                      % converged
     flag =  0;
  elseif ( rho == 0.0 ),                  % breakdown
     flag = -1;
  else                                    % no convergence
     flag = 1;
  end

% END cgs.m
