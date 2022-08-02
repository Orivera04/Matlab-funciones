function C = symadd(A,B)
%SYMADD	Symbolic addition.
%	SYMADD(A,B) symbolically computes A + B.
%
%	Example:
%	    symadd('cos(t)','t') returns 'cos(t)+t'
%
%	See also SYMOP, SYMSUB, SYMSUM.

%	Copyright (c) 1993-94 by The MathWorks, Inc.
%	$Revision: 1.4 $  $Date: 1994/01/24 22:37:15 $

if any(symsize(A) ~= symsize(B))
   if prod(symsize(A)) == 1
      A = symmul(A,ones(symsize(B)));
   elseif prod(symsize(B)) == 1
      B = symmul(B,ones(symsize(A)));
   else
      error('Matrix dimensions must agree.')
   end
end
C = symop(A,'+',B);
