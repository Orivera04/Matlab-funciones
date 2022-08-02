function [x, error, iter, flag] = bicgstab(A, x, b, M, max_it, tol)

%  -- Iterative template routine --
%     Univ. of Tennessee and Oak Ridge National Laboratory
%     October 1, 1993
%     Details of this algorithm are described in "Templates for the
%     Solution of Linear Systems: Building Blocks for Iterative
%     Methods", Barrett, Berry, Chan, Demmel, Donato, Dongarra,
%     Eijkhout, Pozo, Romine, and van der Vorst, SIAM Publications,
%     1993. (ftp netlib2.cs.utk.edu; cd linalg; get templates.ps).
%
%  [x, error, iter, flag] = bicgstab(A, x, b, M, max_it, tol)
%
% bicgstab.m solves the linear system Ax=b using the 
% BiConjugate Gradient Stabilized Method with preconditioning.
%
% input   A        REAL matrix
%         x        REAL initial guess vector
%         b        REAL right hand side vector
%         M        REAL preconditioner matrix
%         max_it   INTEGER maximum number of iterations
%         tol      REAL error tolerance
%
% output  x        REAL solution vector
%         error    REAL error norm
%         iter     INTEGER number of iterations performed
%         flag     INTEGER: 0 = solution found to tolerance
%                           1 = no convergence given max_it
%                          -1 = breakdown: rho = 0
%                          -2 = breakdown: omega = 0

  iter = 0;                                          % initialization
  flag = 0;

  bnrm2 = norm( b );
  if  ( bnrm2 == 0.0 ), bnrm2 = 1.0; end

  r = b - A*x;
  error = norm( r ) / bnrm2;
  if ( error < tol ) return, end

  omega  = 1.0;
  r_tld = r;

  for iter = 1:max_it,                              % begin iteration

     rho   = ( r_tld'*r );                          % direction vector
     if ( rho == 0.0 ) break, end

     if ( iter > 1 ),
        beta  = ( rho/rho_1 )*( alpha/omega );
        p = r + beta*( p - omega*v );
     else
        p = r;
     end
 
     p_hat = M \ p;
     v = A*p_hat;
     alpha = rho / ( r_tld'*v );
     s = r - alpha*v;
     if ( norm(s) < tol ),                          % early convergence check
        x = x + alpha*p_hat;
        resid = norm( s ) / bnrm2;
        break;
     end

     s_hat = M \ s;                                 % stabilizer
     t = A*s_hat;
     omega = ( t'*s) / ( t'*t );

     x = x + alpha*p_hat + omega*s_hat;             % update approximation

     r = s - omega*t;
     error = norm( r ) / bnrm2;                     % check convergence
     if ( error <= tol ), break, end

     if ( omega == 0.0 ), break, end
     rho_1 = rho;

  end

  if ( error <= tol | s <= tol ),                   % converged
     if ( s <= tol ),
        error = norm(s) / bnrm2;
     end
     flag =  0;
  elseif ( omega == 0.0 ),                          % breakdown
     flag = -2;
  elseif ( rho == 0.0 ),
     flag = -1;
  else                                              % no convergence
     flag = 1;
  end

% END bicgstab.m
