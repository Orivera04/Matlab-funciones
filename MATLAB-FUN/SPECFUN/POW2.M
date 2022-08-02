%POW2	Scale floating point numbers.  IEEE scalbn().
%
%	x = pow2(y) computes 2 to the power y.
%
%	x = pow2(f,e) for a real matrix f and a matrix of integers e
%	computes x = f .* (2 .^ e).  The result is computed quickly
%	by simply adding e to the floating point exponent of f.
%	This corresponds to the ANSI C function ldexp() and the IEEE
%	floating point standard function scalbn().
%
%	See also LOG2, REALMAX, REALMIN.

%	Copyright (c) 1984-94 by The MathWorks, Inc.
%	Built-in function.
