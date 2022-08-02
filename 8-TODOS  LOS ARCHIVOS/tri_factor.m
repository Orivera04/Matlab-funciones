function [ L, U, U2 ] = tri_factor ( A1, A2, A3 )
%
%  function [ L, U, U2 ] = tri_factor ( A1, A2, A3 )
%
%  TRI_FACTOR computes the LU factors of a compact storage tridiagonal matrix.
%
%  Discussion:
%
%    The algorithm assumes that Gaussian elimination can be performed
%    without pivoting.
%
%    The tridiagonal matrix A is stored in a compact format.
%    A1(1:N-1) contains the elements of the subdiagonal;
%    A2(1:N) contains the elements of the diagonal;
%    A3(1:N-1) contains the elements of the superdiagonal.
%
%    This storage arrangement is suggested by the following pictures:
%
%    Where the entries of A get stored in A1, A2, A3:
%
%      A2(1)  A3(1)  0     0     0
%      A1(1)  A2(2) A3(2)  0     0
%       0     A1(2) A2(3) A3(3)  0
%       0      0    A1(3) A2(4) A3(4)
%       0      0     0    A1(4) A2(5)
%
%    How the entries of A are stored in A1, A2, A3:
%
%      A(2,1)  A(1,1)  A(1,2)
%      A(3,2)  A(2,2)  A(2,3)
%      A(4,3)  A(3,3)  A(3,4)
%      A(5,4)  A(4,4)  A(4,5)
%              A(5,5)
%
%    The output matrices L and U are also stored compactly:
%
%       1      0     0     0     0       U(1)  U2(1)   0     0     0
%      L(1)    1     0     0     0        0     U(2)  U2(2)  0     0
%       0     L(2)   1     0     0        0      0    U(3)  U2(3)  0
%       0      0    L(3)   1     0        0      0     0    U(4)  U2(4)
%       0      0     0    L(4)   1        0      0     0     0    U(5)
%
%     into the vectors L, U and U2:
%
%      L(2,1)  U(1,1)  U(1,2)
%      L(3,2)  U(2,2)  U(2,3)
%      L(4,3)  U(3,3)  U(3,4)
%      L(5,4)  U(4,4)  U(4,5)
%              U(5,5)
%
%  Modified:
%
%    30 March 2000
%
%  Author:
%
%    John Burkardt
%
%  Parameters:
%
%    Input, real A1(N-1), A2(N), A3(N-1), the subdiagonal, diagonal, and
%    superdiagonal elements of the matrix A.
%
%    Output, real L(N-1), the subdiagonal elements of the unit lower
%    triangular factor of A.
%
%    Output, real U(N), U2(N-1), the diagonal and superdiagonal elements
%    of the upper triangular factor of A.
%
L = A1;
U = A2;
U2 = A3;

n = length ( U );

for i = 2 : n
  U(i) = U(i) - U2(i-1) * L(i-1) / U(i-1);
  L(i-1) = L(i-1) / U(i-1);
end
