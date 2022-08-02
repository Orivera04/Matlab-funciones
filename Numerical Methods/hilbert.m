function A = hilbert ( n )
%
% function A = hilbert ( n )
%
%  Discussion:
%
%    HILBERT sets up the Hilbert matrix.
%
%  Example:
%
%    N = 5
%
%    A = [ 1/1  1/2  1/3  1/4  1/5;
%          1/2  1/3  1/4  1/5  1/6;
%          1/3  1/4  1/5  1/6  1/7;
%          1/4  1/5  1/6  1/7  1/8;
%          1/5  1/6  1/7  1/8  1/9 ]
%
%  Modified:
%
%    12 February 2000
%
%  Author:
%
%    John Burkardt
%
%  Parameters:
%
%    Input, integer N, the order of the matrix.
%
%    Output, real A(N,N), the Hilbert matrix.
%
A = zeros ( n, n );
for i = 1 : n
  for j = 1 : n
    A(i,j) = 1 / ( i + j - 1 );
  end
end
