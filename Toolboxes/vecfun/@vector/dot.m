function C=dot(A,B,Aname,Bname)
%DOT  Vector dot product.
%   C = DOT(A,B) returns the dot product of the vector functions
%   A and B.  That is, C = (A,B) = Ax*Bx + Ay*By + Az*Bz.
%
%   See also CROSS.

% Copyright (c) 2001-08-19, B. Rasmus Anthin.

A=vector(A);
B=vector(B);
if ~strcmp(type(A),type(B))
   B=eval([type(B) '2' type(A) '(B)']);
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
if nargin~=4
   Aname=inputname(1);
   Bname=inputname(2);
end
if isempty(Aname)
   Aname=['(' A.fx ',' A.fy ',' A.fz ')'];
end
if isempty(Bname)
   Bname=['(' B.fx ',' B.fy ',' B.fz ')'];
end
C.f=[Aname char(183) Bname];
C.F=['(' A.Fx '.*' B.Fx '+' A.Fy '.*' B.Fy '+' A.Fz '.*' B.Fz ')'];
C.coords=A.coords;
C=scalar(C);