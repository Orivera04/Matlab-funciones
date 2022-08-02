function A = random_orthogonal ( n )
%
%  RANDOM_ORTHOGONAL returns a random orthogonal matrix.
%
%
%  Modified:
%
%    22 March 2000
%
%  Author:
%
%    John Burkardt
%
%  Parameters:
%
%    Input, integer N, the order of A.
%
%    Output, real A(N,N), the orthogonal matrix.
%
A = eye ( n );
%
%  Pick a random angle of rotation in every plane defined by two axes.
%
for i = 1 : n
  for j = i+1: n

    theta = 2.0 * pi * rand;
    cost = cos ( theta );
    sint = sin ( theta );

    for k = 1 : n
      aik = A(i,k);
      ajk = A(j,k);
      A(i,k) =   cost * aik + sint * ajk;
      A(j,k) = - sint * aik + cost * ajk;
    end

  end

end

