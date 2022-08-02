function [ P, L, U ] = ge_pp ( A )
%
%  function [ P, L, U ] = ge_pp ( A )
%
%  Purpose:
%
%    GE_PP performs Gaussian elimination with partial pivoting.
%
%  Discussion:
%
%    GE_PP is given an N by N matrix A.  It performs Gaussian elimination
%    with partial pivoting, seeking to produce 
%
%      P, a permutation matrix,
%      L, a unit lower triangular matrix,
%      U, an upper triangular matrix
%
%    such that:
%
%      A = P * L * U
%
%    This code will produce such a factorization EVEN IF A IS SINGULAR.
%
%  Modified:
%
%    15 February 2000
%
%  Author:
%
%    John Burkardt
%
%  Parameters:
%
%    Input, real A(N,N), the matrix to be factored.
%
%    Output, real P(N,N), the permuation matrix, or pivot factor.
%
%    Output, real L(N,N), the unit lower triangular mattrix, or multiplier factor.
%
%    Output, real U(N,N), the upper triangular factor.
%
[ n, n ] = size ( A );
%
%  We start with a simple version of the factorization.
%
P = eye ( n );
L = eye ( n );
U = A;
%
%  On step K, we want to choose a pivot row in U, from among rows K through N,
%  by finding the largest entry in U(K:N,K).
%
for k = 1 : n-1

  [ colmax, i ] = max ( abs ( U(k:n, k ) ) );
%
%  After adjusting the MATLAB output index, we then want to switch 
%  rows K and I of U and L, and record the pivot row in P.
%
  i = k+i-1;
  if i ~= k
    U( [k, i], : ) = U( [i, k], : );
    L( [k, i], 1:k-1 ) = L( [i, k], 1:k-1 );
    P( :, [k,i] ) = P( :, [i,k] );
  end
%
%  If the pivot entry is zero, the matrix is singular.  
%  But we can still factor it, so don't exit the routine.
%
  if ( U(k,k) ~= 0.0 ) 
%
%  Now we compute in L the multipliers necessary to zero out the entries 
%  in column K of U, below the pivot entry.
%
%  We are essentially carrying out a "FOR I = K+1 : N" loop here, but
%  doing it in a way that runs more quickly.
%
    i = k+1: n;

    L(i,k) = U(i,k) / U(k,k);
%
%  We zero out the sub-pivot entries,...
%
    U(i,k) = 0.0;
%
%  ...and we subtract the appropriate multiple of row K from each lower row.
%
    U(i,i) = U(i,i) - L(i,k) * U(k,i);

  end 

end



