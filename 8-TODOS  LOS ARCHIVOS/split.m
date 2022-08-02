function [ M, N, b ] = split( A, b, w, flag )
%
% function [ M, N, b ] = split( A, b, w, flag )
%
% split.m sets up the matrix splitting for the stationary
% iterative methods: jacobi and sor (gauss-seidel when w = 1.0 )
%
% input   A        DOUBLE PRECISION matrix
%         b        DOUBLE PRECISION right hand side vector (for SOR)
%         w        DOUBLE PRECISION relaxation scalar
%         flag     INTEGER flag for method: 1 = jacobi
%                                           2 = sor
%
% output  M        DOUBLE PRECISION matrix
%         N        DOUBLE PRECISION matrix such that A = M - N
%         b        DOUBLE PRECISION rhs vector ( altered for SOR )

  [m,n] = size( A );
       
  if ( flag == 1 ),                   % jacobi splitting

     M = diag(diag(A));
     N = diag(diag(A)) - A;

  elseif ( flag == 2 ),               % sor/gauss-seidel splitting

     b = w * b;
     M =  w * tril( A, -1 ) + diag(diag( A ));
     N = -w * triu( A,  1 ) + ( 1.0 - w ) * diag(diag( A ));

  end;

% END split.m
