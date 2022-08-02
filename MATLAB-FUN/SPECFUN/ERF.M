function z = erf(x,y)
%ERF	The error function.
%	y = erf(x).
%	y = 2/sqrt(pi) * integral from 0 to x of exp(-t^2) dt.
%
%	See also ERFC, ERFCX, ERFINV.

%	Ref: Abramowitz & Stegun, Handbook of Mathemtical Functions, sec. 7.1.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

% Derived from a FORTRAN program by W. J. Cody.
% See ERFCORE.

if nargin == 1
	z = erfcore(x,0);
elseif nargin == 2
	if max(size(x))==1 | max(size(y))==1
		if ~finite(y) & ~isnan(y) & y>0
			z = erfcore(x,1);
		elseif ~finite(x) & ~isnan(x) & x<0
			z = 1 + erfcore(x,1);
		else
			error('Invalid input arguments.');
		end
	else
		z = erfcore(y,1)-erfcore(x,1);
	end
end
		

