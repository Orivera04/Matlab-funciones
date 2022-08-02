function r = vpa(s,d)
%VPA	Variable precision arithmetic.
%	VPA(A) numerically evaluates each element of A using variable
%	precision floating point arithmetic with D decimal digit accuracy
%	where D is the current setting of DIGITS.
%
%	VPA(A,D) uses D digits, instead of the current setting of DIGITS.
%
%	Each element of the result is a "symbolic number", which is a string 
%	containing the multi-digit representation.
%
%	VPA, with no arguments, evaluates the previous symbolic expression.
%
%   Examples, matrices:
%	    vpa(hilb(2),25) returns
%	    [                        1., .5000000000000000000000000]
%	    [.5000000000000000000000000, .3333333333333333333333333]
%
%	    vpa(hilb(2),5) returns
%	    [    1., .50000]
%	    [.50000, .33333]
%
%	Examples, functional form:
%	    phi = '(1+sqrt(5))/2'      is the "golden ratio".
%	    vpa(phi,75)                is a string containing 75 digits of phi.
%
%	Examples, command form:
%	    vpa pi 1919                is a screen full of pi.
%	    vpa exp(pi*sqrt(163)) 36   shows an "almost integer".
%
%	See also NUMERIC, DIGITS.

%	Copyright (c) 1993-94 by The MathWorks, Inc.
%	$Revision: 1.7 $  $Date: 1994/01/24 22:37:22 $

if nargin == 0
   r = maple('evalf','"');
elseif nargin == 1
   r = maple('evalf',s);
else
   r = maple('evalf',s,d);
end
