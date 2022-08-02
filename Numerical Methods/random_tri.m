function A = random_tri ( n )
%
% function A = random_tri ( n )
%
%  Discussion:
%
%    RANDOM_TRI returns a random tridiagonal matrix.
%    
%  Modified:
%
%    28 March 2000
%
%  Author:
%
%    John Burkardt
%
%  Parameters:
%
%    Input, integer N, the order of the matrix.
%
%    Output, real A(N,N), the random tridiagonal matrix.
%
A = zeros ( n, n );

for i = 2 : n
  A(i,i-1) = floor ( 10 * rand - 5 );
end

for i = 1 : n
  A(i,i) = floor ( 10 * rand - 5 );
end

for i = 1: n-1
  A(i,i+1) = floor ( 10 * rand - 5 );
end
