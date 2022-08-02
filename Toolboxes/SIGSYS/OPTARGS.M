function fcall=optargs(FUN,a,b,var);
%OPTARGS Optional parameter arguments call string.
%	FCALL = OPTARGS(FUN,N) returns a string argument for EVAL
%	with N optional parameters.  OPTARGS is used in functions
%	that take optional trailing arguments:
%	   myfun(a,b,'fun',P1,P2,P3,...)
%	The string returned will be of the form 'fun(x,P1,P2,P3)'
%	where fun is replaced by the string in FUN.  For example,
%		optargs('myfcn',2) returns 'myfcn(x,P1,P2)'.
%
%	FCALL = OPTARGS(FUN,START,END) returns an EVAL'able string
%	with parameters that go from START to END.  optargs(fun,N)
%	produces the same string as optargs(fun,1,N).
%
%	FCALL = OPTARGS('',N,'') or FCALL = OPTARGS('',START,END,'') returns
%	the optional parameter list only.  For example, OPTARGS('',3,'')
%	returns '(P1,P2,P3)'.
%
%	FCALL = OPTARGS(FUN,...,VAR) uses the string in VAR instead
%	of x for the first argument to FUN.   Use VAR = '' to omit
%	the first argument.
%
%	OPTARGS(FUN,...) returns FUN if the string FUN contains
%	any characters with ASCII value < 48.

%	Author(s): C. Thompson
%	Copyright (c) 1984-94 by The MathWorks, Inc.
%	$Revision: 1.5 $  $Date: 1994/01/25 17:59:34 $

if nargin<1, error('Not enough input arguments.'); end
if isstr(FUN) & any(FUN<48), fcall = FUN; return, end

if nargin==1, error('Not enough input arguments.'); end
if nargin==2, 
  b = a; a = 1; var = 'x';
elseif nargin==3, 
  if isstr(b) | length(b)==0, var = b; b = a; a = 1; else var = 'x'; end
end

% Form call string
if length(var)~=0, comma = ','; else comma = []; end
if b>=a, 
  params = [var,comma,'P',int2str(a)];
else
  params = var;
end
for i=a+1:b,
  params = [params,',P',int2str(i)];
end
if length(params)==0, fcall = FUN; else fcall = [FUN,'(',params,')']; end
