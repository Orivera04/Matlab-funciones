function y = acsch(z)
%ACSCH	Inverse hyperbolic cosecant.
%	ACSCH(X) is the inverse hyperbolic cosecant of the elements of X.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

y = asinh(1./z);
