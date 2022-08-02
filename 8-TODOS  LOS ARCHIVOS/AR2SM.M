function A = ar2sm(A)
%AR2SM	Convert Maple array to symbolic matrix.
%	A = AR2SM(M) converts most instances of the MATRIX([[...],[...]])
%	or VECTOR([...]) forms produced by Maple linear algebra functions
%	to symbolic matrices.
%
%	See also SM2AR.

%	Copyright (c) 1993-94 by The MathWorks, Inc.
%	$Revision: 1.7 $  $Date: 1994/01/24 22:36:48 $

% The cases not handled include the multi-vector data structure returned
% by Maple's "eigenvects", which is processed by the Toolbox's "eigensys".

% Empty set

if length(A) < 6
   if strcmp(A,'{}'), A = []; end
   return
end

% Turn set of vectors into a matrix.

if all(findstr(A,'{VECTOR') == 1)
   s = find(A == '[');
   e = find(A == ']');
   res = A(s(1):e(1));
   for j = 2:length(e)
      res = str2mat(res,A(s(j):e(j)));
   end
   A = transpose(comstack(res));

% Single vector.

elseif all(findstr(A,'VECTOR') == 1)
   s = find(A == '[');
   e = find(A == ']');
   A = A(s:e);

% Single matrix.

elseif all(findstr(A,'MATRIX') == 1)
   s = find(A == '[');
   e = find(A == ']');
   s(1) = [];
   e(length(e)) = [];
   res = A(s(1):e(1));
   for j = 2:length(e)
      res = str2mat(res,A(s(j):e(j)));
   end
   A = comstack(res);
end
