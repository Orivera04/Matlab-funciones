function r = allvalues(s)
% ALLVALUES Find all values for RootOf expression.
%	ALLVALUES(S), where S is a symbolic expression or symbolic column
%	vector containing the sub-expression 'RootOf(EXPR)', finds the roots 
%	of EXPR and then evalutes S.  The result is a vector of all possible 
%	values of S.
%
%	Example: 
%	   p = 'x^5 + x^4 + 2'
%	   s = solve(p)
%	   allvalues(s)
%
%	See also SOLVE, EIGENSYS, NUMERIC.

%	Copyright (c) 1993-94 by The MathWorks, Inc.
%	$Revision: 1.8 $  $Date: 1994/01/24 22:36:47 $

r = [];
for k = 1:symsize(s,1)
   [t,st] = maple(['transpose(stack(vector([allvalues(' sym(s,k,1) ')])))']);
   if st == 0
      r = str2mat(r,t);
   elseif st == 1
      error('Maple result too long.')
   elseif length(t) == 48
      error('Improper RootOf() expression.')
   else
      error(t)
   end
end
r(1,:) = [];
r = comstack(r);
