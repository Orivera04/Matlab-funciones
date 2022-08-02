function [ A1, A2, A3 ] = tri_random ( n )
%
% function [ A1, A2, A3 ] = tri_random ( n )
%
%  Discussion:
%
%    TRI_RANDOM returns a random compact tridiagonal matrix.
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
%    Output, real A1(N-1), A2(N), A3(N-1), the random compact tridiagonal matrix.
%
A1 = floor ( 10 * rand ( n-1, 1 ) - 5 );
A2 = floor ( 10 * rand ( n,   1 ) - 5 );
A3 = floor ( 10 * rand ( n-1, 1 ) - 5 );

