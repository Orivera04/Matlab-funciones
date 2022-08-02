function [ A1, A2, A3 ] = tri_dif2 ( n )
%
% function [ A1, A2, A3 ] = tri_dif2 ( n )
%
%  Discussion:
%
%    TRI_DIF2 sets up the second difference matrix in compact tridiagonal format.
%
%  Example:
%
%    N = 5
%
%    A = [ -2  1  0  0  0;
%           1 -2  1  0  0;
%           0  1 -2  1  0;
%           0  0  1 -2  1;
%           0  0  0  1 -2 ]
%
%    A1, A2, A3=
%
%     1  -2   1
%     1  -2   1
%     1  -2   1
%     1  -2   1
%        -2
%
%  Modified:
%
%    04 April 2000
%
%  Author:
%
%    John Burkardt
%
%  Parameters:
%
%    Input, integer N, the order of the matrix.  N should be at least 2.
%
%    Output, real A1(N-1), A2(N), A3(N-1), the subdiagonal, diagonal, and
%    superdiagonal elements of the matrix A.
%
A1 =         ones ( n-1, 1 );
A2 = - 2.0 * ones ( n,   1 );
A3 =         ones ( n-1, 1 );

