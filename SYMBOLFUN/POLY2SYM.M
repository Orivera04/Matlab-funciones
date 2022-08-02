function p = poly2sym(c,x)
%POLY2SYM Polynomial coefficient vector to symbolic polynomial.
%	POLY2SYM(c) returns a symbolic representation of the 
%	polynomial whose coefficents are in the numeric vector c. The 
%	symbolic variable is x. 
%
%	The coefficients are approximated, if necessary, by the 
%	rational values obtained from SYMRAT. If x has a numeric value 
%	and the elements of c are reproduced exactly by RATS, 
%	EVAL(POLY2STR(c)) returns the same value as POLYVAL(c,x).
%
%	POLY2SYM(c,'v') generates the polynomial in v.
%
%	Example:
%	    poly2sym([1 0 -2 -5]) = 'x^3 - 2*x - 5'.
%
%	See also SYM2POLY, POLYVAL, SYMRAT.

%	Copyright (c) 1993-94 by The MathWorks, Inc.
%	$Revision: 1.7 $  $Date: 1994/01/24 22:37:07 $

if nargin < 2, x = 'x'; end
if all(c == 0), p = '0'; return, end

n = length(c);
p = symmul(sym(1,n,[x '^(' int2str(n) '-j)']),sym(c.'));
