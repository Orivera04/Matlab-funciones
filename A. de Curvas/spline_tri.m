function A = spline_tri ( v )
%
% function A = splint_tri ( v )
%
%  Discussion:
%
%    SPLINE_TRI sets up the tridiagonal cubic spline system matrix.
%
%  Example:
%
%    cs_mat ( 5 ):
%
%    A = [ 2  1  0  0  0;
%          1  4  1  0  0;
%          0  1  4  1  0;
%          0  0  1  4  1;
%          0  0  0  1  2 ]
%
%    cs_mat ( [ 1, 2, 3, 4 ] ):
%
%    A = [ 2  1  0  0  0 ;
%          1  6  2  0  0 ;
%          0  2 10  3  0 ;
%          0  0  3 14  4 ;
%          0  0  0  4  8 ]
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
%    Input, integer V.
%    If V is a scalar, then it represents the order of the matrix, and
%    the vector data is assumed to be all 1's.
%    If V is a vector, then the matrix is assumed to have order one greater
%    than the length of V.
%
%    Output, real A(N,N), the cubic spline matrix.
%
if ( length ( v ) == 1 )
  n = v;
  v = ones ( n-1, 1 );
else
  [nrow,ncol] = size ( v );
  if ( nrow == 1 ) 
    v = v';
    n = ncol;
  elseif ( ncol == 1 )
    n = nrow;
 else
    fprintf ( 'SPLINE_MAT - Fatal error!\n' );
    return
  end
end

A =       diag ( v, -1 ) ...
  + 2.0 * diag ( [v;0] + [0;v],  0 ) ...
  +       diag ( v, +1 );
