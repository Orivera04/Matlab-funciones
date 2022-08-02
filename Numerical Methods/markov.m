function A = markov ( n )
%
% function A = markov ( n )
%
%  Discussion:
%
%    MARKOV returns a random Markov matrix.
%
%    A Markov matrix, also called a "stochastic" matrix, is distinguished
%    by two properties:
%
%    * All matrix entries are nonnegative;
%    * The sum of the entries in each row is 1.
%
%  Example:
%
%    0.1 0.2 0.3 0.4
%    1.0 0.0 0.0 0.0
%    0.5 0.2 0.3 0.0
%    0.2 0.2 0.2 0.4
%    0.2 0.2 0.2 0.4
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
A = rand ( n, n );

for i = 1 : n
  row_sum = sum ( A(i,1:n) );
  A(i,1:n) = A(i,1:n) / row_sum;
end
