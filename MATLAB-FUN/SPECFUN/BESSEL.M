function b = bessel(alpha,xx)
%BESSEL	Bessel functions of various kinds.
%	The suite of M-files for Bessel functions has been modified and
%	extended since the reference manuals for MATLAB 3.5 and 4.0 were
%	printed.  The underlying algorithms have been substantially
%	improved.  There are now four primary functions for real X.
%
%	    BESSELJ(ALPHA,X)  Bessel functions of the first kind,
%	    BESSELY(ALPHA,X)  Bessel functions of the second kind,
%	    BESSELI(ALPHA,X)  Modified Bessel functions of the first kind,
%	    BESSELK(ALPHA,X)  Modified Bessel functions of the second kind.
%
%	An old function, BESSELA(ALPHA,X), accepts complex X, but may
%	produce inaccurate results for large ALPHA or large X.
%
%	This M-file, BESSEL(ALPHA,X), calls BESSELJ(ALPHA,X) if X is real,
%	BESSELI(ALPHA,X) if X is imaginary, and BESSELA(ALPHA,X) if X
%	is complex.  The auxilliary routine BESSELN is no longer used.
%	BESSELH has been superceded by BESSELY.

%	C. Moler, 10/12/92.
%	Copyright (c) 1984-94 by The MathWorks, Inc.

resize = (length(alpha) == 1);
if resize, resize = size(xx); end
xx = xx(:);
b = zeros(length(xx),length(alpha));

% Real x.

v = find(imag(xx(:)) == 0);
if any(v)
   b(v,:) = besselj(alpha,xx(v));
end


% Imaginary x.

v = find(real(xx(:)) == 0);
if any(v)
   if alpha == fix(alpha)
      sig = [1 i -1 -i];
      sig = sig(rem(alpha,4)+1);
   else
      sig = i^(alpha);
   end
   b(v,:) = sig*besseli(alpha,imag(xx(v)));
end

% Complex x.

v = find((real(xx(:)) ~= 0) & (imag(xx(:)) ~= 0));
if any(v)
   b(v,:) = bessela(alpha,xx(v));
end

if resize
   b = reshape(b,resize(1),resize(2));
end
