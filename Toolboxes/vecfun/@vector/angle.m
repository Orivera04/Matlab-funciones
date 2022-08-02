function C=angle(A,B)
%ANGLE  Angle between vectors.
%   ANGLE(V,W) returns the angle between two vector functions, in radians.
%
%   See also ABS.

% Copyright (c) 2001-04-17, B. Rasmus Anthin.

As=isscalar(A);Bs=isscalar(B);
A=vector(A);
B=vector(B);
if isempty(str2num(A.fx)) &...
      isempty(str2num(A.fy)) &...
      isempty(str2num(A.fz)) &...
      ~strcmp(type(A),type(B))
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

C=vec2sca(A,1);
C=acos(dot(A,B)/(abs(A)*abs(B)));
C=struct(C);

if isempty(inputname(1))
   Aname=['(' A.fx ',' A.fy ',' A.fz ')'];
else
   Aname=inputname(1);
end
if isempty(inputname(2))
   Bname=['(' B.fx ',' B.fy ',' B.fz ')'];
else
   Bname=inputname(2);
end
C.f=['/_ ' Aname ' , ' Bname];
C=scalar(C);