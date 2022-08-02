function r = numeric(s)
%NUMERIC Convert symbolic matrix to MATLAB numeric form.
%	NUMERIC(S) converts the symbolic matrix S to numeric form. 
%	S must not contain any symbolic variables.
%
%	NUMERIC, with no arguments, converts the previous symbolic expression.
%
%	Examples:
%	    phi = '(1+sqrt(5))/2' is "golden ratio".
%	    numeric(phi) is the MATLAB numeric representation of phi.
%	    In this case, numeric(phi) is the same as eval(phi).
%
%	    A = gallery(3) and A = gallery(5) have sensitive eigenvalues.
%	    numeric(eigensys(A)) is slower, but more accurate, than eig(A).
%
%	See also VPA.

%	Copyright (c) 1993-94 by The MathWorks, Inc.
%	$Revision: 1.6 $  $Date: 1994/01/24 22:37:06 $

% First, numerically evaluate in Maple.

if nargin == 0
   s = maple('evalf','"');
else
   s = maple('evalf',s);
end

% If too many digits, reevaluate to avoid overflow.

d = digits;
if d > 200
   digits(25);
   s = maple('evalf',s);
   digits(d);
end

% Now, convert Maple's string numbers to MATLAB's floating point.

for k = 1:size(s,1)
  r(k,:) = eval(s(k,:));
end
