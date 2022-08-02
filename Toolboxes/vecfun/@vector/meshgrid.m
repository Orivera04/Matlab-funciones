function [Fx,Fy,Fz,X,Y,Z]=meshgrid(f)
%MESHGRID  Generate meshgrids.
%   [FX,FY,FZ,X,Y,Z] = MESHGRID(V) generates meshgrids for the
%   vector function V.
%
%   Example:
%
%      f = vector('sin(x)','sin(.5*y)','cos(.3*z)');
%      [Fx,Fy,Fz,X,Y,Z] = meshgrid(f);
%      quiver3(X,Y,Z,Fx,Fy,Fz)

% Copyright (c) 2001-08-28, B. Rasmus Anthin.

[x y z]=vars(f);
[X Y Z]=meshgrid(linspace(f.x(1),f.x(2),f.x(3)),...
   linspace(f.y(1),f.y(2),f.y(3)),...
   linspace(f.z(1),f.z(2),f.z(3)));
eval([x '=X;'])
eval([y '=Y;'])
eval([z '=Z;'])
Fx=eval(f.Fx);
Fy=eval(f.Fy);
Fz=eval(f.Fz);
if isconst(f,1),Fx=Fx*ones(size(X));end
if isconst(f,2),Fy=Fy*ones(size(X));end
if isconst(f,3),Fz=Fz*ones(size(X));end