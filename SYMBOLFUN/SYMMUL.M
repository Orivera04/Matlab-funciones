function C = symmul(A,B)
%SYMMUL	Symbolic multiplication.
%	SYMMUL(A,B), for symbolic expressions or matrices A and B,
%	computes the symbolic linear algebraic product A * B .
%
%	Example: symmul('x','exp(x)') returns 'x*exp(x)'
%
%	See also SYMOP, SYMDIV, SYMPOW.

%	Copyright (c) 1993-94 by The MathWorks, Inc.
%	$Revision: 1.3 $  $Date: 1994/01/24 22:37:16 $

if prod(size(A)) == 1
   if A == 0 | A == '0'
      C = sym(zeros(symsize(B)));
      return
   end
end
if prod(size(B)) == 1
   if B == 0 | B == '0'
      C = sym(zeros(symsize(A)));
      return
   end
end
      
C = symop(A,'*',B);
