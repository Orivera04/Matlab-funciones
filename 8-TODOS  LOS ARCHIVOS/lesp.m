function A = lesp ( n )
%
%  function A = lesp ( n )
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
%  Modified:
%
%    04 April 2000
%
%  Parameters:
%
%    Input, integer N, the order of the matrix.
%
%    Output, real A(N,N), the Lesp matrix.
%
A =   diag ( ones ( 1,n-1 ) ./ [2:n], -1 ) ...
    + diag ( -2*[2:n+1] - 1, 0 ) ...
    + diag ( [2:n], +1 );
