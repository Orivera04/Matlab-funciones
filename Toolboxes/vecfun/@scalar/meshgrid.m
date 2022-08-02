function [F,X,Y,Z]=meshgrid(f)
%MESHGRID  Generate meshgrids.
%   [F,X,Y,Z] = MESHGRID(S) generates meshgrids for the
%   scalar function S.
%
%   Example:
%
%      f = scalar('sin(x)+sin(.5*y)-cos(.3*z)');
%      [F,X,Y,Z] = meshgrid(f);
%      slice(X,Y,Z,F,0,0,0)

% Copyright (c) 2001-08-28, B. Rasmus Anthin.

[x y z]=vars(f);
[X Y Z]=meshgrid(linspace(f.x(1),f.x(2),f.x(3)),...
   linspace(f.y(1),f.y(2),f.y(3)),...
   linspace(f.z(1),f.z(2),f.z(3)));
eval([x '=X;'])
eval([y '=Y;'])
eval([z '=Z;'])
F=eval(f.F);
if isconst(f),F=F*ones(size(X));end