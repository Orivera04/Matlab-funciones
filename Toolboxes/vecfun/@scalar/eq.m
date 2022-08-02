function yy=eq(A,B)
%==  Equal.
%   S == T does a comparison between the scalar functions
%   S and T and returns 1 if the relation is true and 0 if it is not.

% Copyright (c) 2001-04-17, B. Rasmus Anthin.

A=scalar(A);
B=scalar(B);
if ~strcmp(type(A),'cart')
   A=eval([type(A) '2cart(A)']);
end
if ~strcmp(type(B),'cart')
   B=eval([type(B) '2cart(B)']);
end
X=linspace(min(A.x(1),B.x(1)),max(A.x(2),B.x(2)),max(A.x(3),B.x(3)));
Y=linspace(min(A.y(1),B.y(1)),max(A.y(2),B.y(2)),max(A.y(3),B.y(3)));
Z=linspace(min(A.z(1),B.z(1)),max(A.z(2),B.z(2)),max(A.z(3),B.z(3)));
[x y z]=meshgrid(X,Y,Z);
vars={x y z};
yy=all(all(all(eval(A.F)==eval(B.F))));