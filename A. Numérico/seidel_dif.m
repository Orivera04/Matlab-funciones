function A = seidel_dif ( n )
%
% function A = seidel_dif ( n )
%
%  Discussion:
%
%    SEIDEL_DIF returns the Gauss-Seidel iteration matrix for the difference matrix.
%
%    For any matrix B, the Gauss-Seidel iteration matrix A can be written as:
%
%      A = - inv ( L + D ) * U
%
%    where 
%
%      D is the diagonal of B, 
%      L is the strict lower triangle of B,
%      U is the strict upper triangle of B.
%   
%  Modified:
%
%    02 April 2000
%
%  Author:
%
%    John Burkardt
%
%  Parameters:
%
%    Input, integer N, the order of the matrix.
%
%    Output, real A(N,N), the matrix.
%
LPD =     diag ( ones ( n-1, 1 ), -1 ) ...
  - 2.0 * diag ( ones ( n,   1 ),  0 );

U = diag ( ones ( n-1, 1 ), +1 );

A = - inv ( LPD ) * U;

