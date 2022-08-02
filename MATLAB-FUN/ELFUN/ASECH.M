function y = asech(z)
%ASECH	Inverse hyperbolic secant.
%	ASECH(X) is the inverse hyperbolic secant of the elements of X.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

y = acosh(1./z);
