function [U,S,V] = singvals(A)
%SINGVALS Symbolic matrix singular values and singular vectors.
%
%	SINGVALS(A) computes symbolic singular values of a matrix A.
%
%	SINGVALS(VPA(A)) computes numerical singular values using variable
%	precision arithmetic.
%
%	[U,S,V] = SINGVALS(VPA(A)) produces two variable precision orthogonal
%	matrices, U and V, and a diagonal vpa matrix, S, so that
%
%	    symop(U,'*',S,'*',transpose(V))
%
%	equals A.
%
%	Symbolic singular vectors are not directly available.
%
%	Examples:
%
%	    A = sym('[a, b, c; 0, a, b; 0, 0, a]');
%	    s = singvals(A)
%
%	    A = magic(8);
%	    s = singvals(A)
%	    [U,S,V] = singvals(vpa(A))
%
%	See also EIGENSYS, VPA.

%	Copyright (c) 1993-94 by The MathWorks, Inc.
%	$Revision: 1.4 $  $Date: 1994/01/24 22:37:11 $

% Check for vpa.

isvpa = (isstr(A) & all(all(('0'<=A & A<='9') | ...
      A=='.' | A==',' | A=='[' | A==']' | A==' ' | A=='e' | A=='-')));

% Singular values only, symbolic or variable precision.

if nargout <= 1
   if isvpa
      if prod(symsize(A)) == 1
         U = A;
      else
         U = maple(['transpose(stack(evalf(Svd(' sm2ar(A) '))))']);
      end
   else
      if ~isstr(A)
         A = sym(A);
      end
      if prod(symsize(A)) == 1
         U = A;
      else
         U = maple(['transpose(stack([singularvals(' sm2ar(A) ')]))']);
      end
   end

% Singular values and vectors, variable precision only.

else
   if isvpa
      if prod(symsize(A)) == 1
         U = 1; S = A; V = 1;
      else
         mpa('U','U');
         mpa('V','V');
         s = maple(['transpose(stack(evalf(Svd(' sm2ar(A) ',U,V))))']);
         S = sym(zeros(symsize(A)));
         for k = 1:min(symsize(A))
            S = sym(S,k,k,sym(s,k,1));
         end
         U = maple('print','U');
         V = maple('print','V');
      end
   else
      error('Symbolic singular vectors are not available.')
   end
end
