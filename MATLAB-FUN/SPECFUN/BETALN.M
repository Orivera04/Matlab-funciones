function y = betaln(z,w)
%BETALN	Logarithm of beta function.
%	y = betaln(z,w).
%	z and w must be compatible for addition.
%
%	See also BETAINC, BETA.
%	Ref: Abramowitz & Stegun, sec. 6.2.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

y = gammaln(z)+gammaln(w)-gammaln(z+w);
