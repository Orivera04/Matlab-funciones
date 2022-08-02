function r = symdiff(s,a2,a3)
%SYMDIFF Symbolic differentiation.
%	This function is usually called by DIFF to compute derivatives.
%	SYMDIFF(S) differentiates S with respect to its free variable.
%	SYMDIFF(S,'v') differentiates S with respect to 'v'.
%	SYMDIFF(S,n) and SYMDIFF(S,'v',n) differentiate S n times.
%	SYMDIFF, with no arguments, differentiates the previous expression.

%	Copyright (c) 1993-94 by The MathWorks, Inc.
%	$Revision: 1.8 $  $Date: 1994/01/24 22:37:15 $

if strcmp(s,'ans') | strcmp(s,'"')
   s = maple('"');
end
if nargin <= 1
   x = symvar(s);
   nd = 1;
end
if nargin >= 2
   if any(isletter(a2))
      x = a2;
      nd = 1;
   else
      x = symvar(s);
      nd = a2;
   end
end
if nargin == 3
   nd = a3;
end
if isstr(nd)
   nd = eval(nd);
end
if nd < 0
   error('Please use INT to differentiate a negative number of times.')
elseif nd == 0
   r = s;
else
   if nd > 1
      x = [x '$' int2str(nd)];
   end
   if s(1) ~= '['
      r = maple('diff',s,x);
   else
      r = maple('map','diff',s,x);
   end
end
