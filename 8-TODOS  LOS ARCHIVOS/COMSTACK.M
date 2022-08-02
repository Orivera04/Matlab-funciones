function A = comstack(A)
%COMSTACK Stack up the commas in a symbolic matrix.
%	A = comstack(A) inserts blanks in the symbolic matrix A
%	so that all its commas line up.

%	Copyright (c) 1993-94 by The MathWorks, Inc.
%	$Revision: 1.5 $  $Date: 1994/01/24 22:36:50 $

[m,n] = symsize(A);

% Remove []'s from scalar
if m*n == 1
   if A(1) == '['
      A([1, length(A)]) = [];
   end
   return
end

% Find width of final result.

p = 1;
for j = 1:n
   for i = 1:m
      c = [find(A(i,:) == '[') findcomma(A(i,:)) find(A(i,:) == ']')];
      k(i) = c(j+1)-c(j);
   end
   p = p + max(k);
end

% If necessary, pad rows with blanks.

w = size(A,2);
if p > w
   A = [A setstr(' '*ones(m,p-w))];
   w = p;
end

% Now rearrange blanks to line up the commas.

s = 1;
for j = 1:n
   for i = 1:m
      c = [findcomma(A(i,:)) find(A(i,:) == ']')];
      k(i) = c(j);
   end
   e = max(k);
   for i = 1:m
      A(i,:) = [A(i,1:s) blanks(e-k(i)) A(i,s+1:w-e+k(i))];
   end
   s = e;
end
