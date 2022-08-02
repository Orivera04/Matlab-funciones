function S = speye(m,n)
%SPEYE 	Sparse identity matrix.
%	SPEYE(M,N) forms an M-by-N sparse matrix with 1's on
%	the main diagonal.  SPEYE(N) abbreviates SPEYE(N,N).
%	SPEYE(SIZE(A)) is a space-saving SPARSE(EYE(SIZE(A))).

%	Copyright (c) 1984-94 by The MathWorks, Inc.

if nargin < 2
   if length(m) == 1
      n = m;
   elseif length(m) == 2
      n = m(2);
      m = m(1);
   else 
      error('Please use SPEYE(N), SPEYE(M,N) or SPEYE([M,N]).')
   end
end
k = 1:round(min(m,n));
S = sparse(k,k,1,m,n);
