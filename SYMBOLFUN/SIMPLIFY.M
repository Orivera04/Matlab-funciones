function r = simplify(s)
%SIMPLIFY Symbolic simplification.
%	SIMPLIFY(S) simplifies each element of the symbolic matrix S.
%
%	Example: simplify('sin(x)^2 + cos(x)^2') is 1 .
%
%	See also SIMPLE, FACTOR, EXPAND, COLLECT.

%	Copyright (c) 1993-94 by The MathWorks, Inc.
%	$Revision: 1.5 $  $Date: 1994/01/24 22:37:10 $

if nargin == 0
   s = maple('"');
elseif strcmp(s,'ans')
   s = maple('"');
end
if s(1) ~= '['
   r = maple('simplify',s);
else
   r = maple('map','simplify',s);
end
