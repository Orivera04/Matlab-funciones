function c = sym2poly(p)
%SYM2POLY Symbolic polynomial to polynomial coefficient vector.
%	SYM2POLY(p) returns the vector of coefficients of the symbolic
%	polynomial p.
%
%	Example:
%	    sym2poly('x^3 - 2*x - 5') = [1 0 -2 -5].
%
%	See also POLY2SYM, POLYVAL.

%	Copyright (c) 1993-94 by The MathWorks, Inc.
%	$Revision: 1.7 $  $Date: 1994/05/23 16:14:11 $

x = symvar(p);
maple(['ans := ' p]);
c = fliplr(eval(maple(['[seq(coeff(",' x ',k),k=0..degree(ans))]'])));
