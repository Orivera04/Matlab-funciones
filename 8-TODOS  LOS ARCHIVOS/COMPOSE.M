function h = compose(f,g,u,v);
%COMPOSE Functional composition.
%	COMPOSE(f,g), where f and g are symbolic expressions that represent
%	functions, say f(y) and g(x), returns a symbolic expression representing 
%	the function f(g(x)). 
%
%	COMPOSE(f,g,'u') uses the variable 'u' as the domain
%	variable for both f and g. f and g have the following forms:
%	f = f(u,a1,a2,...); g = g(u,b1,b2,...)
%
%	COMPOSE(f,g,'u','v') uses the variable 'u' as the domain
%	variable for f and 'v' for g. f and g have the following forms:
%	    f = f(u,a1,a2,...); g = g(v,b1,b2,...)
%
%	Example: compose 1/(1+x^2) sin(x) is
%	    1/(1+sin(x)^2)
%
%	See also FINVERSE, SYMVAR, SUBS.

%	Copyright (c) 1993-94 by The MathWorks, Inc.
%	$Revision: 1.8 $  $Date: 1994/05/23 16:13:29 $

if nargin == 2, x = symvar(g); y= symvar(f);
elseif nargin == 3, x = u; y = u;
elseif nargin == 4, x = v; y = u;
end

maple(['funf := (' y ') -> ' f]);
maple(['fung := (' x ') -> ' g]);
maple(['funh := (' x ') -> (funf@fung)(' x ')']);
h = maple(['funh(' x ')']);

% Patch up special case, f = g, so h = '(@@(f,2))(x)'
if length(h) >= 4
   if strcmp(h(1:4),'(@@(')
      h = [f(1:length(f)-2) g ')'];
   end
end

maple('funf := ''funf'';');
maple('fung := ''fung'';');
maple('funh := ''funh'';');
