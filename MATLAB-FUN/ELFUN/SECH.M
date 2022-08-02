function y = sech(z)
%SECH	Hyperbolic secant.
%	SECH(X) is the hyperbolic secant of the elements of X.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

y = 1./cosh(z);
