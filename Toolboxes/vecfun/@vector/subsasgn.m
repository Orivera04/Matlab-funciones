function A=subsasgn(A,S,B)
%SUBSASGN  Subscripted assignment.
%   V = W assigns the vector function W into V.
%
%   V([],[],[]) = W does the same thing.
%
%   Subscripted assignment is also possible, e.g.
%   V.y = S where S is a scalar.
%
%   See also SUBSREF.

% Copyright (c) 2001-04-17, B. Rasmus Anthin.

err1='Cannot assign to an indexed vector';
[x y z]=vars(A);
if isempty(S(1).type)
   B=vector(B);
   A=B;
elseif strcmp(S(1).type,'()') & length(S(1).subs)==3
   if isempty(S(1).subs{1}) & isempty(S(1).subs{2}) & isempty(S(1).subs{3})
      B=vector(B);
      A=B;
   else
      error([err1 ' with values.']);
   end
elseif strcmp(S(1).type,'.')
   B=scalar(B);
   B=struct(B);
   A.x=[min(A.x(1),B.x(1)) max(A.x(2),B.x(2)) max(A.x(3),B.x(3))];
   A.y=[min(A.y(1),B.y(1)) max(A.y(2),B.y(2)) max(A.y(3),B.y(3))];
   A.z=[min(A.z(1),B.z(1)) max(A.z(2),B.z(2)) max(A.z(3),B.z(3))];
   A.xval=B.xval;A.yval=B.yval;A.zval=B.zval;
   name=inputname(3);
   if isempty(inputname(3))
      name=B.f;
   end
   switch(S(1).subs)
   case {x}
      A.fx=name;A.Fx=B.F;
   case {y}
      A.fy=name;A.Fy=B.F;
   case {z}
      A.fz=name;A.Fz=B.F;
   end
   A.coords=B.coords;
   A=vector(A);
else
   error([err1 ' using ''{}''.']);
end