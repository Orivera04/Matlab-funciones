function [ A1, A2, A3 ] = tri_lesp ( n )
%
% function [ A1, A2, A3 ] = tri_lesp ( n )
%
%  Discussion:
%
%    TRI_LESP sets up the Lesp matrix in compact tridiagonal format.
%
%  Example:
%
%    N = 5
%
%     -5    2    0    0     0
%     1/2  -7    3    0     0
%      0   1/3  -9    4     0
%      0    0   1/4 -11     5
%      0    0    0   1/5  -13
%
%    A1,   A2, A3=
%
%    1/2   -5   2
%    1/3   -7   3
%    1/4   -9   4
%    1/5  -11   5
%         -13
%
%  Modified:
%
%    11 April 2000
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
A1(1:n-1,1) =  1 ./ [2:n]';
A2(1:n,1)   = - 2 * [1:n]' - 3;
A3(1:n-1,1) =       [2:n]';


