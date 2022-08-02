function X = symop(s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14,s15,s16)
%SYMOP	Symbolic operations.
%	SYMOP(arg1,arg2,arg3,...) takes up to 16 arguments. Each argument may
%	be a symbolic matrix, a numeric matrix, or one of the following operators:
%	'+', '-', '*', '/', '^','(',')'.  SYMOP(...) concatenates the arguments
%	and evaluates the resulting expression.
%
%	Examples:
%	    x = 'x'
%	    f = symop(1,'+',x,'+',x,'^',2,'/',2);
%	    symop(f,'-',int(diff(f)))
%	    symop('exp(x)','/','(',f,'+',x,'^3','/',6,')')
%
%	    G = sym('[c, s; -s, c]')
%	    symop(G,'*',transpose(G))
%
%	Warning: Mixing scalars and matrices might give unexpected results.
%	For example, symop(A,'+',x) adds x to the diagonal of A.
%
%	See also SYMADD, SYMSUB, SYMMUL, SYMDIV, SYMPOW.

%	Copyright (c) 1993-94 by The MathWorks, Inc.
%	$Revision: 1.12 $  $Date: 1994/05/23 16:14:21 $

mat = zeros(1,nargin);
T = [];
for k = 1:nargin
   eval(['s = s' int2str(k) ';']);
   if ~isstr(s)
      if prod(size(s)) > 1
         s = sym(s);
      else
         s = symrat(s);
      end
   end
   if s(1) == '['
      s = sm2ar(s);
      mat(k) = 1;
      if k > 2
         if mat(k-2) & mat(k-1)=='*'
            T = [T(1:length(T)-1) '&*'];
         end
      end
   elseif s == '*'
      mat(k) = '*';
   elseif length(s) > 1 & any( s=='+' | s=='-' | s=='/')
      s = ['(' s ')'];
   end
   T = [T s];
end
if any(mat==1);
   T = ['evalm(' T ')'];
end
X = maple(['ans := ' T]);
