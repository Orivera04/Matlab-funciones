function r = symsum(f,x,a,b)
%SYMSUM	Symbolic summation.
%	SYMSUM(S) is the indefinite summation of S with respect to its symbolic
%	variable.  See SYMVAR for definition of "symbolic variable".
%	SYMSUM(S,'v') is the indefinite summation of S with respect to v.
%	SYMSUM, with no arguments, is the indefinite summation of the previous
%	expression with repect to its symbolic variable.
%	SYMSUM(S,a,b) is the definite summation of S with respect to its
%	    symbolic variable from a to b.
%	SYMSUM(S,'v',a,b) is the definite summation of S with respect to v
%	    from a to b.
%
%	Examples:
%	    symsum k^2                   1/3*k^3-1/2*k^2+1/6*k
%	    symsum k^2 0 n-1             1/3*n^3-1/2*n^2+1/6*n
%	    symsum k^2 0 10              385
%	    symsum k^2 11 10             0
%	    symsum 1/k^2                 -Psi(1,k)
%	    symsum 1/k^2 1 Inf           1/6*pi^2
%	    symsum x^k/k! k 0 Inf        exp(x)
%
%	See also SYMVAR, INT, SYMADD.

%	Copyright (c) 1993-94 by The MathWorks, Inc.
%	$Revision: 1.4 $  $Date: 1994/01/24 22:37:20 $

if nargin == 0
   f = maple('"');
elseif strcmp(f,'ans')
   f = maple('"');
end

if f(1) ~= '['
   % Scalar symbolic expression
   if nargin <= 2
      % Indefinite summation
      if nargin < 2, x = symvar(f); end
      r = maple('sum',f,x); 
   else
      % Definite summation
      if nargin < 4, b = a; a = x; x = symvar(f); end
      r = maple('sum',f,[x '=' symrat(a) '..' symrat(b)]);
   end
else
   % Symbolic matrix.
   if nargin <= 2
      % Indefinite summation
      if nargin < 2, x = symvar(f); end
      r = maple('map','sum',f,x);
   else
      % Definite summation
      if nargin < 4, b = a; a = x; x = symvar(f); end
      r = maple('map','sum',f,[x '=' symrat(a) '..' symrat(b)]);     
   end
end
