function [V,E] = eigensys(A)
%EIGENSYS Symbolic matrix eigenvalues and eigenvectors.
%
%	EIGENSYS(A) computes symbolic eigenvalues of a matrix A.
%
%	EIGENSYS(VPA(A)) computes numeric eigenvalues using variable precision
%	arithmetic.
%
%	[V,E] = EIGENSYS(A) computes a symbolic vector E containing the
%	eigenvalues and a symbolic matrix V containing the eigenvectors of
%	a numeric or symbolic matrix A. The eigenvectors may be expressed 
%	in terms of E(n), where n is a positive integer that indexes the 
%	eigenvalue vector E.
%
%	[V,E] = EIGENSYS(VPA(A)) computes numeric eigenvalues and eigenvectors
%	using variable precision arithmetic.
%
%	Examples:
%	    eigensys(rosser)
%	    [v,e] = eigensys(sym('[a,b,c; b,c,a; c,a,b]'))
%
%	See also CHARPOLY, JORDAN, SINGVALS, VPA.

%	Copyright (c) 1993-94 by The MathWorks, Inc.
%	$Revision: 1.11 $  $Date: 1994/01/24 22:36:53 $

% Check for vpa.

if isstr(A) & all(all(('0'<=A & A<='9') | ...
      A=='.' | A==',' | A=='[' | A==']' | A==' ' | A=='e' | A=='-'))
   if nargout < 2
      V = maple(['transpose(stack(evalf(Eigenvals(' sm2ar(A) '))))']);
   else
      mpa('V','V');
      E = maple( ...
         ['transpose(stack(evalf(Eigenvals(' sm2ar(A) ',''V''))))']);
      V = maple('print','V');
   end
   return
elseif ~isstr(A)
   A = sym(A);
end

% Eigenvalues only
if nargout < 2
   if prod(symsize(A)) == 1
      V = A;
   else
      V = maple(['transpose(stack(vector([eigenvals(' sm2ar(A) ')])))']);
   end

% Eigenvalues and vectors

else
   s = maple('eigenvects',A);

% Set up indices for parsing Maple result
   p = find(s == '[');
   q = find(s == ']');
   r = [0 find(s(q-1) == '}')];

% Initialize output vectors
   E = [];
   V = [];
   k = 0;

% loop over each e'val/multiplicity/e'vect triple

   for j = 1:length(r)-1
      v = s(p(r(j)+1):q(r(j+1)));
      c = find(v == ',');

% get the triple
      e = v(2:c(1)-1);
      am = eval(v(c(1)+1:c(2)-1));  % am = algebraic multiplicity
      v = v(c(2)+3:length(v)-2);

% ALLVALUE any RootOf expression
      if findstr(e,'RootOf')
         er = e;
         e = maple('allvalues',e);
      else
         er = [];
      end

      g = [findstr(v,'VECTOR') length(v)+3];
      gm = length(g)-1;    % gm = geometric multiplicity

      while ~isempty(e)

         c = min([find(e==',') length(e)+1]);
         f = e(1:c-1);
         e(1:c) = [];

         for i = 1:am
            if isempty(E), E = f; else, E = [E ',' f]; end
         end

         for i = 1:gm
            k = k+1;
            u = v(g(i)+7:g(i+1)-4);
            if ~isempty(er)
               u = subs(u,['E(' int2str(k) ')'],er);
            end
            V = str2mat(V,u);
         end

      end

   end
   E = transpose(sym(E));
   V(1,:) = [];
   V = transpose(comstack(V));
end
