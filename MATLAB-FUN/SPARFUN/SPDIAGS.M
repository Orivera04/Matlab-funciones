function [res1,res2] = spdiags(arg1,arg2,arg3,arg4)
% SPDIAGS Extract and create sparse band and diagonal matrices.
%
%	SPDIAGS, which generalizes the builtin function "diag", deals with
%	three matrices, in various combinations, as both input and output.
%	A is an m-by-n matrix, usually (but not necessarily) sparse,
%	with its nonzero, or specified, elements located on p diagonals.
%	B is a min(m,n)-by-p matrix, usually (but not necessarily) full,
%	whose columns are the diagonals of A.
%	d is a vector of length p whose integer components specify
%	the diagonals in A.
%
%	Roughly, A, B and d are related by
%	    for k = 1:p
%	        B(:,k) = diag(A,d(k))
%	    end
%
%	Four different operations, distinguished by the number of
%	input arguments, are possible with SPDIAGS:
%
%	Extract all nonzero diagonals:
%	    [B,d] = spdiags(A);
%	Extract specified diagonals:
%	    B = spdiags(A,d);
%	Replace specified diagonals:
%	    A = spdiags(B,d,A);
%	Create a sparse matrix from its diagonals:
%	    A = spdiags(B,d,m,n);
%
%	The precise relationship among A, B and d is:
%	   if m >= n
%	      for k = 1:p
%	         for j = max(1,1+d(k)):min(n,m+d(k))
%	            B(j,k) = A(j-d(k),j);
%	         end
%	      end  
%	   if m < n
%	      for k = 1:p
%	         for i = max(1,1-d(k)):min(m,n-d(k))
%	            B(i,k) = A(i,i+d(k));
%	         end
%	      end  
%	   end
%	Some elements of B, corresponding to positions "outside" of A,
%	are not defined by these loops.  They are not referenced when
%	B is input and are set to zero when B is output.
%
%	For example, this generates a sparse tridiagonal representation
%	of the classic second difference operator on n points.
%
%	    e = ones(n,1);
%	    A = spdiags([e -2*e e], -1:1, n, n)
%
%	This turns it into Wilkinson's test matrix (see WILKINSON(n)).
%
%	    A = spdiags(abs(-(n-1)/2:(n-1)/2)',0,A)
%
%	Finally, this recovers the 3 diagonals.
%
%	    B = spdiags(A)
%
%	The second example is not square.
%
%	    A = [ 11    0   13    0
%	           0   22    0   24
%	           0    0   33    0
%	          41    0    0   44
%	           0   52    0    0
%	           0    0   63    0
%	           0    0    0   74]
%
%	has m = 7, n = 4 and p = 3.
%
%	The statement [B,d] = spdiags(A)  produces d = [-3 0 2]'  and
%	 
%	    B = [ 41   11    0
%	          52   22    0
%	          63   33   13
%	          74   44   24 ]
%
%	Conversely, with the above B and d, the expression
%	spdiags(B,d,7,4) reproduces the original A.
%
%	See also DIAG.

%	Rob Schreiber, RIACS, and Cleve Moler, 2/13/91, 6/1/92.
%	Copyright (c) 1984-94 by The MathWorks, Inc.


if nargin <= 2
   % Extract diagonals
   A = arg1;
   if nargin == 1
      % Find all nonzero diagonals
      [i,j] = find(A);
      d = sort(j-i);
      d = d(find(diff([-inf; d])));
   else
      % Diagonals are specified
      d = arg2;
   end
   [m,n] = size(A);
   p = length(d);
   B = zeros(min(m,n),p);
   for k = 1:p
      if m >= n
         i = max(1,1+d(k)):min(n,m+d(k));
      else
         i = max(1,1-d(k)):min(m,n-d(k));
      end
      B(i,k) = diag(A,d(k));
   end
   res1 = B;
   res2 = d;
end

if nargin >= 3
   % Create a sparse matrix from its diagonals
   B = arg1;
   d = arg2;
   p = length(d);
   moda = (nargin == 3);
   if moda
      % Modify a given matrix
      A = arg3;
   else
      % Start from scratch
      A = sparse(arg3,arg4);
   end
   % Process A in compact form
   [i,j,a] = find(A);
   a = [i j a];
   [m,n] = size(A);
   for k = 1:p
      if moda
         % Delete current d(k)-th diagonal
         i = find(a(:,2)-a(:,1) == d(k));
         a(i,:) = [];
      end 
      % Append new d(k)-th diagonal to compact form
      i = (max(1,1-d(k)):min(m,n-d(k)))';
      a = [a; i i+d(k) B(i+(m>=n)*d(k),k)];
   end
   res1 = sparse(a(:,1),a(:,2),full(a(:,3)),m,n);
end
