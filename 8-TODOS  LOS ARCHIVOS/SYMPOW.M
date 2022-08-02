function B = sympow(A,p)
%SYMPOW	Power of a symbolic expression or matrix.
%	SYMPOW(S,p) computes S^p. If S is a scalar symbolic expression, p may 
%	be a scalar symbolic or scalar numeric expression. If S is a symbolic 
%	matrix, S must be square, and p must be an integer.
%
%	Example: sympow('exp(t)',2) returns 'exp(t)^2'.
%
%	See also SYMOP, SYMMUL.

%	Copyright (c) 1993-94 by The MathWorks, Inc.
%	$Revision: 1.4 $  $Date: 1994/01/24 22:37:18 $

if prod(symsize(A)) > 1
   if symsize(A,1) ~= symsize(A,2)
      error('First argument must be a square matrix.')
   elseif p ~= fix(p)
      error('Second argument must be an integer.')
   end
end
B = symop(A,'^',p);
