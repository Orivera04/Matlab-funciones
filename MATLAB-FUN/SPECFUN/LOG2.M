%LOG2	Dissect floating point numbers.   IEEE logb().
%	y = LOG2(x) computes the logarithm base 2 of the elements of x.
%
%	[f,e] = LOG2(x) for a real matrix x, returns a matrix f of real
%	numbers, usually in the range 0.5 <= abs(f) < 1, and a matrix
%	e of integers, so that  x = f .* 2.^e.  Any zeros in x produce
%	f = 0 and e = 0.  This corresponds to the ANSI C function frexp()
%	and the IEEE floating point standard function logb().
%
%	See also POW2, NEXTPOW2, REALMAX, REALMIN.

%	Copyright (c) 1984-94 by The MathWorks, Inc.
%	Built-in function.
