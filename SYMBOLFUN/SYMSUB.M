function C = symsub(A,B)
%SYMSUB	Symbolic subtraction.
%	SYMSUB(A,B), for symbolic expressions or matrices A and B,
%	computes A - B .
%
%	See also SYMOP, SYMADD.

%	Copyright (c) 1993-94 by The MathWorks, Inc.
%	$Revision: 1.5 $  $Date: 1994/01/24 22:37:19 $

if any(symsize(A) ~= symsize(B))
   if prod(symsize(A)) == 1
      A = symmul(A,ones(symsize(B)));
   elseif prod(symsize(B)) == 1
      B = symmul(B,ones(symsize(A)));
   else
      error('Matrix dimensions must agree.')
   end
end
A = sym(A);
B = sym(B);
if all(size(A) == size(B))
   if all(all(A == B))
      C = sym(zeros(symsize(A)));
      return
   end
end
C = symop(A,'-',B);
