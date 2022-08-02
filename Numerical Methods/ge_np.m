function [ L, U ] = ge_np ( A )
%
%  function [ L, U ] = ge_np ( A )
%
%  Purpose:
%
%    GE_NP performs Gaussian elimination with no pivoting.
%
%  Discussion:
%
%    GE_NP is given a square matrix A.  It performs Gaussian elimination,
%    seeking to produce 
%
%      L, a unit lower triangular matrix,
%      U, an upper triangular matrix,
%
%    such that:
%
%      A = L * U
%
%    This process may fail, even for nonsingular A.  If only one output
%    argument is specified, then L and U are returned in a packed format
%    in a single matrix.
%
%  Modified:
%
%    12 February 2000
%
%  Parameters:
%
%    Input, real A(N,N), the matrix to be factored.
%
%    Output, real L(N,N), the unit lower triangular factor.
%
%    Output, real U(N,N), the upper triangular factor.
%
[ n, n ] = size ( A );
%
%  On step K, we focus on A(K,K), and eliminate the nonzero entries "beneath" it.
%
for k = 1 : n-1

  if ( A(k,k) == 0 )
    error ( 'Elimination breaks down with zero pivot.  Quitting...' )
  end
%
%  Divide the rest of column K by A(K,K).
%
  A(k+1:n,k) = A(k+1:n,k) / A(k,k);
%
%  Subtract the appropriate multiple of row K from each lower row.
%  Study these two lines and make sure you see what is happening.
%
  i = k+1: n;
  A(i,i) = A(i,i) - A(i,k) * A(k,i);

end
%
%  If only one output argument, return the LU factors in one matrix,
%  otherwise, split them up.
%
if ( nargout <= 1 )
  L = A;
else
  L = tril ( A, -1 ) + eye ( n );
  U = triu ( A );
end

