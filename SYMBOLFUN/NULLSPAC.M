function Z = nullspace(A)
%NULLSPACE Basis for null space.
%	The columns of Z = NULLSPACE(A) form a basis for the null space of A.
%	SYMSIZE(Z,2) is the nullity of A.  SYMMUL(A,Z) is zero.
%	If A has full rank, Z is empty.
%
%	See also COLSPACE, LINSOLVE, NULL.

%	Copyright (c) 1993-94 by The MathWorks, Inc.
%	$Revision: 1.5 $  $Date: 1994/05/31 22:35:53 $

if prod(symsize(A)) == 1
   if A == 0, Z = sym(1); else, Z = []; end
else
   Z = maple('nullspace',A);
end
