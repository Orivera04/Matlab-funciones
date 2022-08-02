function r = horner(p)
%HORNER	Horner polynomial representation.
%	HORNER(P) transforms the symoblic polynomial, P, into its Horner,
%	or nested, representation.
%
%	Example:
%	    If p = 'x^3-6*x^2+11*x-6'
%	    then horner(p) 'x*(x*(x-6)+11)-6'.
%
%	See also SIMPLIFY, EXPAND, SIMPLE, COLLECT, FACTOR.

%	Copyright (c) 1993-94 by The MathWorks, Inc.
%	$Revision: 1.3 $  $Date: 1994/01/24 22:36:57 $

if nargin == 0
   p = maple('"');
elseif strcmp(p,'ans')
   p = maple('"');
end
if p(1) ~= '['
   r = maple('convert',p,'horner');
else
   r = maple('map','convert',p,'horner');
end
