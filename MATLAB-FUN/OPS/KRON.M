function K = kron(A,B)
%KRON	Kronecker tensor product.
%	KRON(X,Y) is the Kronecker tensor product of X and Y.
%	The result is a large matrix formed by taking all possible
%	products between the elements of X and those of Y.   For
%	example, if X is 2 by 3, then KRON(X,Y) is
%
%	   [ X(1,1)*Y  X(1,2)*Y  X(1,3)*Y
%	     X(2,1)*Y  X(2,2)*Y  X(2,3)*Y ]
%
%	If either X or Y is sparse, only nonzero elements are multiplied
%	in the computation, and the result is sparse.

%	Full: J. N. Little, 4-21-85.
%	Sparse: T. R. Gardos (Georgia Tech), 5-4-93.
%	Copyright (c) 1984-94 by The MathWorks, Inc.

[ma,na] = size(A);
[mb,nb] = size(B);

if issparse(A) | issparse(B)

   % At least one input is sparse, so result is sparse.
   % Break apart the sparse matrices.

   [ia,ja,sa] = find(A);
   [ib,jb,sb] = find(B);
   nza = nnz(A);
   nzb = nnz(B);

   % Set aside memory for the result.

   nzc = nza*nzb;
   ic = zeros(nzc,1);
   jc = zeros(nzc,1);
   sc = zeros(nzc,1);
   
   % Compute nonzeros in the result, nzb elements at a time.

   if nzc > 0
      k = 1:nzb;
      for m = 1:nza
          ic(k) = (ia(m)-1)*mb + ib;
          jc(k) = (ja(m)-1)*nb + jb;
          sc(k) = sa(m)*sb;
          k = k + nzb;
      end
   end

   % Put the pieces together. 

   K = sparse(ic,jc,sc,ma*mb,na*nb);

else

   % Both inputs full, so result is full.

   K = zeros(ma*mb,na*nb);
   if ma*na <= mb*nb
       for i = 1:ma
           ik = 1+(i-1)*mb:i*mb;
           for j = 1:na
               jk = 1+(j-1)*nb:j*nb;
               K(ik,jk) = A(i,j)*B;
           end
       end
   else
       for i = 1:mb
           ik = i:mb:(ma-1)*mb+i;
           for j = 1:nb
               jk = j:nb:(na-1)*nb+j;
               K(ik,jk) = B(i,j)*A;
           end
       end
   end
end
