function g = finverse(f,x)
%FINVERSE Functional inverse.
%	g = FINVERSE(f) returns the functional inverse of f. 
%	f is a symbolic expression representing a function of exactly 
%	one symbolic variable, say 'x'. Then g is a symbolic expression 
%	that satisfies g(f(x)) = x.
%
%	g = FINVERSE(f,'v') uses the symbolic variable 'v' as the 
%	independent variable. Then g is a symbolic expression that 
%	satisfies g(f(v)) = v. Use this form when f contains more than 
%	one symbolic variable.
%
%	Example: finverse('1/tan(x)') is 'arctan(1/x)'
%
%	See also COMPOSE, SYMVAR.

%	Copyright (c) 1993-94 by The MathWorks, Inc.
%	$Revision: 1.6 $  $Date: 1994/01/24 22:36:55 $

if nargin < 2, x = symvar(f); end

g = maple('solve',[ f '= dummy_y'],x);

if isempty(g)
   disp(['Warning: finverse(' f ') can not be found'])
   g = 'NaN';
else
   c = min(findcomma(g));
   if ~isempty(c)
      disp(['Warning: finverse(' f ') is not unique'])
      g = g(1:c-1);
   end
end

g = subs(g,x,'dummy_y');
