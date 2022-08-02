function y = erfc(x)
%ERFC	The complementary error function.
%	y = erfc(x).
%	y = 2/sqrt(pi) * integral from x to inf of exp(-t^2) dt.
%	  = 1 - erf(x).
%
%	See also ERF, ERFCX.

%	Ref: Abramowitz & Stegun, Handbook of Mathemtical Functions, sec. 7.1.
%	Copyright (c) 1984-94 by The MathWorks, Inc.

% Derived from a FORTRAN program by W. J. Cody.

y = erfcore(x,1);
