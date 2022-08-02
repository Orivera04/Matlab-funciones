function V=horzcat(X,Y,Z)
%HORZCAT  Horizontal concatenation.
%   [S T U] is the horizontal concatenation of three scalar
%   functions S,T and U. [S,T,U] is the same thing.
%   The resulting object is a vector function.

% Copyright (c) 2001-04-17, B. Rasmus Anthin.

X=scalar(X);Y=scalar(Y);Z=scalar(Z);
V.x=[min(min(X.x(1),Y.x(1)),Z.x(1)) max(max(X.x(2),Y.x(2)),Z.x(2)) max(max(X.x(3),Y.x(3)),Z.x(3))];
V.y=[min(min(X.y(1),Y.y(1)),Z.y(1)) max(max(X.y(2),Y.y(2)),Z.y(2)) max(max(X.y(3),Y.y(3)),Z.y(3))];
V.z=[min(min(X.z(1),Y.z(1)),Z.z(1)) max(max(X.z(2),Y.z(2)),Z.z(2)) max(max(X.z(3),Y.z(3)),Z.z(3))];
V.xval=[];V.yval=[];V.zval=[];
if ~strcmp(type(X),type(Y))
   Y=eval([type(Y) '2' type(X) '(Y)']);
end
if ~strcmp(type(X),type(Z))
   Z=eval([type(Z) '2' type(X) '(Z)']);
end
V.fx=X.f;V.fy=Y.f;V.fz=Z.f;
V.Fx=X.F;V.Fy=Y.F;V.Fz=Z.F;
V.coords=X.coords;
V=vector(V);
