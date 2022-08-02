function Q = gram_schmidt ( X )
%
% function Q = gram_schmidt ( X )
%
%  Discussion:
%
%    GRAM_SCHMIDT carries out the Gram-Schmidt orthogonalization process
%    on a set of vectors stored as the columns of X, returning an orthonormal 
%    basis in the columns of Q.  
%
%  Modified:
%
%    20 March 2000
%
%  Author:
%
%    John Burkardt
%
%  Parameters:
%
%    Input, real X(M,N), a matrix regarded as containing N column vectors
%    of length M.
%
%    Output, real Q(M,NQ), a matrix containing NQ column vectors of length M.
%    Each column of Q has unit L2 norm.  Each pair of columns of Q is
%    orthogonal.  The columns of Q span the same space as the columns of X.
%    NQ <= N.
%
[ m, n ] = size ( X );

nq = 0;

for j = 1: n

  for i = 1 : nq
    rij = Q(:,i)' * X(:,j);
    X(:,j) = X(:,j) - Q(:,i) * rij;
  end

  rjj = norm ( X(:,j) );

  if ( rjj ~= 0.0 )
    nq = nq + 1;
    Q(:,nq) = X(:,j) / rjj;
  end 

end

