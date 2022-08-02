function y = humps(x)
%HUMPS	A function used by QUADDEMO, ZERODEMO and FPLOTDEMO.
%	HUMPS(X) is a function with strong maxima near x = .3 and x = .9.
%	See QUADDEMO, ZERODEMO and FPLOTDEMO.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

y = 1 ./ ((x-.3).^2 + .01) + 1 ./ ((x-.9).^2 + .04) - 6;

