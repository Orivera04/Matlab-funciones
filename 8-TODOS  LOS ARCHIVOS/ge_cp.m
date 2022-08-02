function [ P, L, U, Q ] = ge_cp ( A )
%
%  function [ P, L, U, Q ] = ge_cp ( A )
%
%  GE_CP carries out Gaussian elimination with complete pivoting.
%
%  Discussion:
%
%    The factorization of A has the form:
%
%      A = P * L * U * Q.
%
%  Modified:
%
%    15 February 2000
%
%  Parameters:
%
%    Input, real A(N,N), the matrix to be factored.
%
%    Output, real P(N,N), L(N,N), U(N,N), Q(N,N).
%    P is the premultiplying row (equation) permutation matrix,
%    L is the unit lower triangular multiplier matrix,
%    U is the upper triangular factor,
%    Q is the post multiplying column (variable) permutation matrix.
%
[ n, n ] = size ( A );
%
%  Initialize the pivot vectors.
%
pp = 1:n; 
qq = 1:n;
%
%  Carry out the K-th step of elimination.
%
for k = 1: n-1
%
%  Find the largest coefficient in the remaining K by K submatrix.
%
  [ colmaxima, rowindices ] = max ( abs ( A(k:n, k:n) ) );
  [ biggest, colindex ] = max ( colmaxima );
%
%  ROW and COL are the row and column of the largest coefficient.
%  We have to add K-1 because the computed values refer to the local
%  coordinates in the submatrix.
%
  row = rowindices(colindex)+k-1; 
  col = colindex+k-1;
%
%  Swap rows K and ROW.
%  Swap columns K and COL.
%
  A( [k, row], : ) = A( [row, k], : );
  A( :, [k, col] ) = A( :, [col, k] );
%
%  Update the permutation index vectors.
%
  pp( [k, row] ) = pp( [row, k] ); 
  qq( [k, col] ) = qq( [col, k] );
%
%  If the pivot value is nonzero, we now perform this step of elimination.
%
  if ( A(k,k) ~= 0 )

    i = k+1:n;
%
%  Divide the entries "below" the pivot value.
%
    A(i,k) = A(i,k) / A(k,k);
%
%  Subtract a multiple of the K-th row from the later rows.
%
    A(i,i) = A(i,i) - A(i,k) * A(k,i);

  end

end
%
%  This program actually uses compressed data structures 
%  during the computation.  Now we expand the data out to a full form 
%  more convenient for the user.
%
P = eye ( n ); 
P = P(pp,:); 

L = tril ( A, -1 ) + eye ( n );
U = triu ( A );

Q = eye ( n ); 
Q = Q(:,qq); 

