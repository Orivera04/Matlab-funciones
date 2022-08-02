function x = tri_solve ( L, U, U2, b )
%
%  function x = tri_solve ( L, U, U2, b )
%
%  TRI_SOLVE solves a tridiagonal linear system factored by TRI_FACTOR.
%
%  Modified:
%
%    01 April 2000
%
%  Author:
%
%    John Burkardt
%
%  Parameters:
%
%    Input, real L(N-1), the subdiagonal elements of the unit lower
%    triangular factor of A.
%
%    Input, real U(N), U2(N-1), the diagonal and superdiagonal elements
%    of the upper triangular factor of A.
%
%    Input, real b(N), the right hand side.
%
%    Output, real x(N), the solution of the linear system.
%
n = length ( U );
%
%  Solve L * y = b.
%
y = zeros(n,1);
y(1) = b(1);
for i = 2 : n
  y(i) = b(i) - L(i-1) * y(i-1);
end
%
%  Solve U * x = y.
%
x = zeros(n,1);
for i = n : -1 : 2
  x(i) = y(i) / U(i);
  y(i-1) = y(i-1) - U2(i-1) * x(i);
end
x(1) = y(1) / U(1);
