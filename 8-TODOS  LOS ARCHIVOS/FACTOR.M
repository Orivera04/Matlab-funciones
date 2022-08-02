function r = factor(s)
%FACTOR	Symbolic factorization.
%	FACTOR(S), if S is a symbolic matrix, factors each element of S.
%	FACTOR(N), if N is a matrix with integer elements, computes the prime
%	factorization of each element of N.
%
%	See also SIMPLIFY, EXPAND, SIMPLE, COLLECT.

%	Copyright (c) 1993-94 by The MathWorks, Inc.
%	$Revision: 1.8 $  $Date: 1994/01/24 22:36:54 $

if nargin == 0
   s = maple('"');
elseif ~isstr(s)
   s = sym(s);
elseif strcmp(s,'ans')
   s = maple('"');
end

% Factor integers.

if ~any(isletter(s))
   if s(1) ~= '['
      r = maple('ifactor',s);
   else
      r = maple('map','ifactor',s);
   end

% Factor symbolic expressions.

else
   if s(1) ~= '['
      r = maple('factor',s);
   else
      r = maple('map','factor',s);
   end
end
