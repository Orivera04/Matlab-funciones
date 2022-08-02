function B = colspace(A)
%COLSPACE Basis for column space.
%	The columns of B = COLSPACE(A) form a basis for the column space of A.
%	SYMSIZE(B,2) is the rank of A.
%
%	See also NULLSPACE, ORTH.

%	Copyright (c) 1993-94 by The MathWorks, Inc.
%	$Revision: 1.4 $  $Date: 1994/01/24 22:36:49 $

if prod(symsize(A)) == 1
   if A ~= 0, B = sym(1); else, B = []; end
else
   B = maple('colspace',A);
end
