function M = sym(a1,a2,a3,a4,a5);
%SYM	Create, access, or modify a symbolic matrix.
%	A symbolic matrix is a MATLAB text array where each row begins with
%	'[', ends with ']', and contains substrings separated by commas,
%	representing the individual elements.
%
%	There are three ways to create symbolic matrices:
%
%	SYM(X) converts the numeric matrix X to its symbolic form with exact
%	rational representation (obtained from SYMRAT) of the elements.
%
%	SYM(m,n,'expr') creates an m-by-n symbolic matrix whose elements
%	are expr evaluated for i = 1:m and j = 1:n. expr is a
%	symbolic expression, usually containing the characters 'i' and 'j', 
%	and possibly other free variables.  
%	SYM(m,n,'r','c','expr') uses 'r' and 'c'as the row and column 
%	variables instead of 'i' and 'j'.
%
%	SYM('[s11,s12,...,s1n; s21,s22,...; ...,smn]') creates an m-by-n 
%	symbolic matrix using the symbolic elements s11, s12, ..., smn. 
%	This form of sym mimics the generation of numeric matrices in MATLAB.
%	Semicolons terminate rows.
%
%	There are two ways to access individual elements of a symbolic matrix:
%    
%	SYM(S,i,j,'expr') is the symbolic version of S(i,j) = 'expr'.
%
%	r = SYM(S,i,j) is the symbolic version of r = S(i,j).
%
%
%	Examples:
%
%	    M = sym(hilb(3)) is a text matrix with three rows,
%	        [  1, 1/2, 1/3]
%	        [1/2, 1/3, 1/4]
%	        [1/3, 1/4, 1/5]
%
%	    M = sym(3,3,'1/(i+j-t)') generalizes this by producing
%	        [1/(2-t), 1/(3-t), 1/(4-t)]
%	        [1/(3-t), 1/(4-t), 1/(5-t)]
%	        [1/(4-t), 1/(5-t), 1/(6-t)]
%
%	    M = sym(M,1,3,'1/t') changes the (1,3) element of M to '1/t'.
%
%	    M = sym('a, 2*b, 3*c; 0, 5*b, 6*c; 0, 0, 7*c') generates an upper
%	    triangular symbolic matrix for which determ(M) is 35*a*b*c.
%
%	    For this later M, sym(M,1,3) is '3*c'.
%
%	See also VPA, SYMOP.

%	Copyright (c) 1993-94 by The MathWorks, Inc.
%	$Revision: 1.14 $  $Date: 1994/01/24 22:37:14 $

if nargin == 0
    error('Must have at least one argument.')
end

% M = sym(A)

if nargin == 1
   if ~isstr(a1)
      A = a1;
      [p,q] = size(A);
      M = [];
      for i = 1:p
         s = [];
         for j = 1:q
            s = [ s symrat(A(i,j)) ', '];
         end
         M = str2mat(M,['[' s(1:length(s)-2) ']']);
      end
      if p > 0, M(1,:) = []; end
   end
end

% s = sym(M,i,j)

if nargin == 3
   if ~isstr(a3)
      M = a1; i = a2; j = a3;
      if ~isstr(M), M = sym(M); end
      M = M(i,:);         
      k = [find(M=='[') findcomma(M) find(M==']')];
      if ~isempty(k), M = M(k(j)+1:k(j+1)-1); end
      k = min(find(M ~= ' '));
      M(1:k-1) = [];
      return
   end
end

% M = sym(M,i,j,'expr')

if nargin == 4
   M = a1; i = a2; j = a3; expr = a4;
   if ~isstr(M), M = sym(M); end
   if ~isstr(expr), expr = symrat(expr); end
   w = size(M,2);
   s = M(i,:);         
   k = [find(s=='[') findcomma(s) find(s==']')];
   if isempty(k)
      s = expr;
   else
      s = [s(1:k(j)) expr s(k(j+1):w)];
   end
   l = length(s);
   if l < w
      s = [s blanks(w-l)];
   elseif l > w
      M = [M setstr(ones(size(M(:,1)))*blanks(l-w))];
   end
   M(i,:) = s;
end

% M = sym(m,n,'expr')

if nargin == 3
   m = a1; n = a2; expr = a3;
   M = maple('matrix',m,n,['(i,j) -> ' expr]);
end

% M = sym(m,n,'r','c','expr')

if nargin == 5
   m = a1; n = a2; r = a3; c = a4; expr = a5;
   M = maple('matrix',m,n,['(' r ',' c ') -> ' expr]);
end

% M = sym('[a11, a12, ; . , amn]')

if nargin == 1
   if isstr(a1)
      if size(a1,1)==1
         M = [];
         if a1(1) == '[', a1(1) = []; end
         if a1(length(a1)) == ']', a1(length(a1)) = []; end
         if a1(length(a1)) ~= ';'; a1 = [a1 ';']; end
         k = find(a1 == ' ');
         if ~isempty(k)
            if k(1) == 1, k(1) = []; end
            k = k(find((a1(k-1) ~= ' ') & (a1(k-1) ~= ';') & ...
                (a1(k+1) ~= ';') & (a1(k-1) ~= ',') & (a1(k+1) ~= ',')));
            a1(k) = ','*ones(size(k));
         end
         while ~isempty(a1);
            k = min(find(a1==';'));
            M = str2mat(M,['[' a1(1:k-1) ']']);
            a1(1:k) = [];
         end
         M(1,:) = [];
      else
         M = a1;
      end
   end
end

M = comstack(M);
