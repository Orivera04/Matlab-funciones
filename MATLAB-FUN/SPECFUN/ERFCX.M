function y = erfcx(x)
%ERFCX	Scaled complementary error function.
%	y = erfcx(x).
%	y = exp(x^2) * erfc(x) ~ (1/sqrt(pi)) * 1/x for large x.
%
%	See also ERF, ERFC.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

% Derived from a FORTRAN program by W. J. Cody.

y = erfcore(x,2);

