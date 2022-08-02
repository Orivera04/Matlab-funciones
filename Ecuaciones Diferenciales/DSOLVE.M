function [y1,y2,y3,y4,y5,y6] = dsolve(a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12)
%DSOLVE	Symbolic solution of ordinary differential equations.
%
%	DSOLVE('eqn1','eqn2', ..) accepts up to 12 input arguments, which are
%	symbolic equations representing ordinary differential equations and
%	initial conditions.  Several equations or initial conditions may be 
%	grouped together, separated by commas, in a single input argument.
%
%	The independent variable is usually 'x'.  This may be changed to 't'
%	by using 'x' as a dependent variable, or by using 't' instead of 'x'
%	as a free variable in an equation.  The independent variable may be
%	changed from 'x' to some other lower case character by including that
%	character as the last input argument.
%
%	The letter 'D' denotes differentiation with respect to the independent
%	variable, i.e. usually d/dx.  A D followed by a digit denotes repeated
%	differentiation, i.e. D2 is d^2/dx^2.  Any characters immediately
%	following these differentiation operators are taken to be the dependent
%	variables, i.e. D3y denotes the third derivative of y(x) or y(t).
%
%	Initial conditions are specified by equations like 'y(a)=b' or 
%	'Dy(a) = b' where y is one of the dependent variables and a and b are
%	constants.  If the number of initial conditions given is less than the
%	number of dependent variables, the resulting solutions will obtain
%	arbitrary constants, C1, C2, etc.
%
%	If the number of output arguments is less than the number of dependent
%	variables, DSOLVE simply returns a list of solutions.
%
%	[Y1,Y2, ...] = DSOLVE( .. ) returns the solutions, in alphabetic order,
%	to the specified output arguments.  For nonlinear equations, if the
%	results are not unique, the outputs may be symbolic vectors.
%
%	Examples:
%
%	    First order equation.
%	       dsolve('Dy = a*y')
%	       dsolve('Df = f + sin(t)')
%	       y = dsolve('(Dy)^2 + y^2 = 1','s')
%
%	    First order equation with an initial condition.
%	       dsolve('Dy = a*y', 'y(0) = b')
%	       dsolve('Df = f + sin(t)', 'f(pi/2) = 0')
%	       y = dsolve('(Dy)^2 + y^2 = 1', 'y(0) = 0', 's')
%
%	    Second order equation.
%	       dsolve('D2y = -a^2*y')
%
%	    Second order equation with boundary conditions.
%	       dsolve('D2y = -a^2*y', 'y(0) = 1, Dy(pi/a) = 0')
%
%	    Two first order equations.
%	       [x,y] = dsolve('Dx = y', 'Dy = -x')
%	       [f,g] = dsolve('Df = 3*f+4*g', 'Dg = -4*f+3*g')
%
%	    Two first order equations with initial conditions.
%	       [x,y] = dsolve('Dx = y', 'Dy = -x', 'x(0)=0', 'y(0)=1')
%	       [f,g] = dsolve('Df = 3*f+4*g, Dg = -4*f+3*g', 'f(0)=0, g(0)=1')
%
%	    Three first order equations with initial conditions.
%	       [u,v,w] = dsolve('Du=v, Dv=w, Dw=-u','u(0)=0, v(0)=0, w(0)=1') 
%
%	    The same problem, as a single third order equation.
%	       w = dsolve('D3w = -w','w(0)=1, Dw(0)=0, D2w(0)=0')
%
%	See also SOLVE.

%	Copyright (c) 1993-94 by The MathWorks, Inc.
%	$Revision: 1.9 $  $Date: 1994/01/24 22:36:52 $

% Pick up the independent variable, if specified.

narg = nargin;
eval(['x = a' int2str(narg) ';'])
if length(x) == 1
   narg = narg - 1;
else
   x = [];
end

% Concatenate the input arguments.

eqn = ['{' a1];
for k = 2: narg
   eval(['eqn = [eqn '', '' a' int2str(k) '];']);
end
eqn = [eqn '}'];

% Find the dependent variables.

d = find(eqn == 'D');
vars = [];
for k = find(eqn == 'D')
   if isletter(eqn(k+1))
      y = eqn(k+1);
   else
      y = eqn(k+2);
   end
   if isempty(find(vars == y))
      vars = [vars y];
   end
end
vars = sort(vars);

% Determine independent variable, if not specified.

if isempty(x)
   n = length(vars);
   v = symvar(eqn,n:n+1);
   if any(v == 'x') & ~any(vars == 'x')
      x = 'x';
   elseif any(v == 't') & ~any(vars == 't')
      x = 't';
   elseif ~any(vars == 'x')
      x = 'x';
   else
      x = 't';
   end
end
if any(vars == x)
   error([x ' appears to be both an independent and a dependent variable.'])
end
parx = ['(' x ')'];

% Expand the abbreviations:
%   Dy(a) -> D(y)(a)
%   Dy -> D(y)(x)
%   Djy(a) -> (D@@j)(y)(a)
%   Djy -> (D@@j)(y)(x)

k = d(1)-1;
eqns = eqn(1:k);
d = [d length(eqn)+1];
for k = 1:length(d)-1
   p = eqn(d(k)+1:d(k+1)-1);
   q = length(p);
   if isletter(p(1));
      Dy = ['D(' p(1) ')'];
      if p(2) ~= '(', Dy = [Dy parx]; end
      eqns = [eqns Dy p(2:q)];
   else
      Dy = ['(D@@' p(1) ')(' p(2) ')'];
      if p(3) ~= '(', Dy = [Dy parx]; end
      eqns = [eqns Dy p(3:q)];
   end
end

% Expand the abbreviation:
%   y -> y(x)

d = []; 
eqns = [' ' eqns ' '];
k = 2:length(eqns)-1;
for y = vars;
   d = [d find((eqns(k) == y) & ~(eqns(k+1) == '(' | eqns(k+1) == ')' ...
          | isletter(eqns(k+1)) | isletter(eqns(k-1))))];
end
eqn = eqns(k);
d = [sort(d) length(eqn)+1];
k = d(1)-1;
eqns = eqn(1:k);
for k = 1:length(d)-1
   p = eqn(d(k):d(k+1)-1);
   q = length(p);
   eqns = [eqns p(1) parx p(2:q)];
end

% Generate list of variables.

varlist = '{';
for y = vars
   varlist = [varlist y parx ','];
end
varlist(length(varlist)) = '}';

% Solve the equation(s).

s = maple('dsolve',eqns,varlist,'explicit');

if isempty(s)
   error('Explicit solution could not be found.')
end

% Remove underscores from integration constants.

k = find(s=='_');
if any(k), s(k) = []; end

% Quick return if not enough output variables.

if length(vars) > max(1,nargout)
   y1 = s(find(s~='{' & s~='}'));
   return
end

% Break apart into output variables.

c = findcomma(s)-1;
l = length(s);
if s(l) == '}', c = [c l-1]; else, c = [c l]; end
for k = 1:length(vars)
   r = [];
   for j = findstr([vars(k) parx ' = '],s);
      r = str2mat(r,['[' s(j+7:min(c(c>j))) ']']);
   end
   r = comstack(r(2:size(r,1),:));
   eval(['y' int2str(k) ' = r;'])
end
