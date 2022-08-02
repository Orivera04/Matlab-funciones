function yy=min(S)
%MIN  Smallest value.
%   MIN(S) returns the smallest value of the scalar function S.
%
%   See also MAX.

% Copyright (c) 2001-04-17, B. Rasmus Anthin.

X=linspace(S.x(1),S.x(2),S.x(3));
Y=linspace(S.y(1),S.y(2),S.y(3));
Z=linspace(S.z(1),S.z(2),S.z(3));
[xs ys zs]=vars(S);
eval(['[' xs ',' ys ',' zs ']=meshgrid(X,Y,Z);'])
vars=eval(['{' xs ',' ys ',' zs '}']);
yy=min(min(min(eval(S.F))));