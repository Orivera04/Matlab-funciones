function p = charpoly(A,x)
%CHARPOLY Symbolic characteristic polynomial.
%	CHARPOLY(A) computes the characteristic polynomial of the matrix A.
%	The result is a symbolic polynomial in 'x'. 
%
%	CHARPOLY(A,'v') uses 'v' instead of 'x'.
%
%	Except for roundoff error, charpoly(A) equals poly2sym(poly(A)) and
%	poly(A) equals sym2poly(charpoly(A)).
%
%	Example:  charpoly(gallery(3)).
%
%	See also POLY, POLY2SYM, SYM2POLY, JORDAN, EIGENSYS, SOLVE.

%	Copyright (c) 1993-94 by The MathWorks, Inc.
%	$Revision: 1.7 $  $Date: 1994/01/24 22:36:48 $

if nargin < 2, x = 'x'; end
if prod(symsize(A)) == 1
   p = symsub(x,sym(A));
else
   p = maple('charpoly',A,x);
end
