function [m,n] = symsize(A,d)
%SYMSIZE Size of a symbolic matrix.
%        D = SYMSIZE(S), for M-by-N matrix S, returns the two-element
%        row vector D = [M, N] containing the number of rows and columns
%        in the matrix.
% 
%        [M,N] = SYMSIZE(S) returns the number of rows and columns
%        in separate output variables.
% 
%        M = SYMSIZE(S,1) returns just the number of rows.
%        N = SYMSIZE(S,2) returns just the number of columns.

%	Copyright (c) 1993-94 by The MathWorks, Inc.
%	$Revision: 1.5 $  $Date: 1994/01/24 22:37:19 $
 
[m,w] = size(A);
if ~isstr(A)
   n = w;
else
   n = length(findcomma(A(1,:))) + 1;
   for i = 2:m
      c = [find(A(i,:) == '[') findcomma(A(i,:)) find(A(i,:) == ']')];
      if length(c) ~= n+1
         disp(A(1,:))
         disp(A(i,:))
         error('All rows should have same separating comma count.')
      end
   end
end

if nargin + nargout > 3
    error('Too many output arguments.')
end
if nargout < 2
   if nargin > 1
      if d == 2
         m = n;
      end
   else
      m = [m n];
   end
end
