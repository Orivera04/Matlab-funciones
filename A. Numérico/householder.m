function H = householder ( R, k )
%
% function H = householder ( R, k )
%
%  Discussion:
%
%    HOUSEHOLDER returns the Householder matrix that zeros out the
%    subdiagonal entries of column K of the matrix R.
%
%  Modified:
%
%    21 March 2000
%
%  Author:
%
%    John Burkardt
%
%  Parameters:
%
%    Input, real R(M,N), the matrix which is upper triangular through
%    column K-1.
%
%    Input, integer K, the column of R to operate on.
%
%    Output, real H(M,M), the Householder matrix that zeros out the
%    subdiagonal entries of column K.
%
[m,n] = size ( R );
%
%  Compute the appropriate vector V.
%
  alpha = - sign ( R(k,k) ) * norm ( R(k:m,k) );

  if ( alpha ~= 0.0 ) 

    v = zeros ( m, 1 );
    v(k) = sqrt ( 0.5 * ( 1.0 - R(k,k) / alpha ) );
    v(k+1:m) = - 0.5 * R(k+1:m,k) / ( alpha * v(k) );  
%
%  Define the reflector matrix H(v).
%
    H = eye ( m ) - 2 * v * v' / ( v' * v );

  else

    H = eye ( m )

  end
