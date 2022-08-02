function r = collect(s,x)
%COLLECT Collect coefficients.
%	COLLECT(S) regards each element of S as a polynomial in the
%	symbolic variable of S.  If the symbolic variable of S is 'x', 
%	COLLECT(S) collects all the coefficients with the same power of 'x'.
%
%	COLLECT(S,'v') takes 'v' to be the symbolic variable in each 
%	element of S.
%
%	See also SYMVAR, SIMPLIFY, SIMPLE, EXPAND, FACTOR.

%	Copyright (c) 1993-94 by The MathWorks, Inc.
%	$Revision: 1.7 $  $Date: 1994/01/24 22:36:49 $

if nargin == 0
   s = maple('"');
elseif strcmp(s,'ans')
   s = maple('"');
end
if nargin < 2, x = symvar(s); end
if s(1) ~= '['
   r = maple('collect',s,x);
else
   r = maple('map','collect',s,x);
end
