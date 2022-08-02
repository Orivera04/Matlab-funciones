function [n,d] = numden(s)
%NUMDEN	Numerator and denominator of a symbolic expression.
%	[N,D] = NUMDEN(A) converts each element of A to a rational 
%	form where the numerator and denominator are relatively prime 
%	polynomials with integer coefficients. 
%
%	Examples: 
%	[n,d] = numden(4/5) returns n = 4 and d = 5.
%	[n,d] = numden('x/y + y/x') returns
%	    n = x^2+y^2 , d = y*x

%	Copyright (c) 1993-94 by The MathWorks, Inc.
%	$Revision: 1.5 $  $Date: 1994/01/24 22:37:06 $

if s(1) ~= '['
   n = maple('numer',s);
   d = maple('denom',s);
else
   n = maple('map','numer',sm2ar(s));
   d = maple('map','denom',sm2ar(s));
end
