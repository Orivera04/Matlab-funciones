function A = hilbert_inv ( n )
%
%  function A = hilbert_inv ( n )
%
%  HILBERT_INV returns the inverse of the Hilbert matrix.
%
%  Modified:
%
%    14 February 2000
%
%  Author:
%
%    John Burkardt
%
%  Parameters:
%
%    Input, integer N, the order of A.
%
%    Output, real A(N,N), the inverse Hilbert matrix.
%
  A = zeros ( n, n );
%
%  Set the (1,1) entry.
%
  A(1,1) = n^2;
%
%  Define Row 1, Column J by recursion on Row 1 Column J-1.
%
  i = 1;
  for j = 2 : n
    A(i,j) = - A(i,j-1) * ( (n+j-1) * (i+j-2) * (n+1-j) ) ...
      / ( (i+j-1) * (j-1)^2 );
  end
%
%  Define Row I by recursion on row I-1.
%
  for i = 2 : n
    for j = 1 : n

      A(i,j) = - A(i-1,j) * ( (n+i-1) * (i+j-2) * (n+1-i) ) ...
        / ( (i+j-1) * (i-1)^2 );

    end
  end

