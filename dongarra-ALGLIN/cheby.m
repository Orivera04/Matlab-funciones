function [x, error, iter, flag] = cheby(A, x, b, M, max_it, tol)

%  -- Iterative template routine --
%     Univ. of Tennessee and Oak Ridge National Laboratory
%     October 1, 1993
%     Details of this algorithm are described in "Templates for the
%     Solution of Linear Systems: Building Blocks for Iterative
%     Methods", Barrett, Berry, Chan, Demmel, Donato, Dongarra,
%     Eijkhout, Pozo, Romine, and van der Vorst, SIAM Publications,
%     1993. (ftp netlib2.cs.utk.edu; cd linalg; get templates.ps).
%
% [x, error, iter, flag] = cheby(A, x, b, M, max_it, tol)
%
% cheby.m solves the symmetric positive definite linear system Ax=b 
% using the Chebyshev Method with preconditioning.
%
% input   A        REAL symmetric positive definite matrix
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

  iter = 0;                                 % initialization
  flag = 0;

  bnrm2 = norm( b );
  if  ( bnrm2 == 0.0 ), bnrm2 = 1.0; end

  r = b - A*x;
  error = norm( r ) / bnrm2;
  if ( error < tol ) return, end

  eigs = eig( inv(M)*A );
  eigmax = max( eigs );
  eigmin = min( eigs );

  c = ( eigmax - eigmin ) / 2.0;
  d = ( eigmax + eigmin ) / 2.0;

  for iter = 1:max_it,                     % begin iteration

    z =  M \ r;
 
    if ( iter > 1 )                        % direction vectors
       beta = ( c*alpha / 2.0 )^2;
       alpha = 1.0 / ( d - beta );
       p = z + beta*p;
    else
       p = z;
       alpha = 2.0 / d;
    end

    x  = x + alpha*p;                      % update approximation

    r = r - alpha*A*p;
    error = norm( r ) / bnrm2;             % check convergence
    if ( error <= tol  ), break, end

  end

  if ( error > tol ) flag = 1; end;        % no convergence

% END cheby.m
