function C=mrdivide(A,B)
%/  Slash or right divide.
%   S/T is the right division of T into S, where S and T
%   are scalar functions.
%
%   See also MLDIVIDE

% Copyright (c) 2001-04-17, B. Rasmus Anthin.

if isnumeric(B)
   B=scalar(cplxread(B),type(A));
elseif isnumeric(A)
   A=scalar(cplxread(A),type(B));
end
if isempty(str2num(A.f)) & ~strcmp(type(A),type(B))
   B=eval([type(B) '2' type(A) '(B)']);
elseif ~strcmp(type(A),type(B))
   A=eval([type(A) '2' type(B) '(A)']);
end
C.x=[min(A.x(1),B.x(1)) max(A.x(2),B.x(2)) max(A.x(3),B.x(3))];
C.y=[min(A.y(1),B.y(1)) max(A.y(2),B.y(2)) max(A.y(3),B.y(3))];
C.z=[min(A.z(1),B.z(1)) max(A.z(2),B.z(2)) max(A.z(3),B.z(3))];
C.xval=[];C.yval=[];C.zval=[];
if ~isempty(A.xval) & ~isempty(B.xval)
   C.xval='*';
end
if ~isempty(A.yval) & ~isempty(B.yval)
   C.yval='*';
end
if ~isempty(A.zval) & ~isempty(B.zval)
   C.zval='*';
end
if isempty(inputname(1))
   Aname=A.f;
else
   Aname=inputname(1);
end
if isempty(inputname(2))
   Bname=B.f;
else
   Bname=inputname(2);
end
findA=any(Aname=='+') | any(Aname=='-') | any(Aname=='*');
findB=any(Bname=='+') | any(Bname=='-') | any(Bname=='*');
if findA & findB
   C.f=['(' Aname ')/(' Bname ')'];
elseif findA & ~findB
   C.f=['(' Aname ')/' Bname];
elseif ~findA & findB
   C.f=[Aname '/(' Bname ')'];
else
   C.f=[Aname '/' Bname];
end
C.F=['(' A.F ')./(' B.F ')'];
C.coords=A.coords;
C=scalar(C);