function A = jacobi_dif ( n )
%
% function A = jacobi_dif ( n )
%
%  Discussion:
%
%    JACOBI_DIF returns the Jacobi iteration matrix for the difference matrix.
%
%    For any matrix B, the Jacobi iteration matrix A can be written as:
%
%      A = - inv ( D ) * ( L + U )
%
%    where 
%
%      D is the diagonal of B, 
%      L is the strict lower triangle of B,
%      U is the strict upper triangle of B.
%
%  Example:
%
%     0.0  0.5  0.0  0.0  0.0
%     0.5  0.0  0.5  0.0  0.0
%     0.0  0.5  0.0  0.5  0.0
%     0.0  0.0  0.5  0.0  0.5
%     0.0  0.0  0.0  0.5  0.0
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
A = 0.5 * ( diag ( ones ( n-1, 1 ), -1 ) ...
          + diag ( ones ( n-1, 1 ), +1 ) );

