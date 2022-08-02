function y=isconst(f)
%ISCONST  True for constant function.
%   ISCONST(F) returns 1 if F is constant and 0 otherwise.
%   F must be of type scalar.

% Copyright (c) 2001-04-13, B. Rasmus Anthin.

error(nargchk(1,1,nargin))
X=linspace(f.x(1),f.x(2),f.x(3));
Y=linspace(f.y(1),f.y(2),f.y(3));
Z=linspace(f.z(1),f.z(2),f.z(3));
[xs ys zs]=vars(f);
eval(['[' xs ',' ys ',' zs ']=meshgrid(X,Y,Z);'])
vars=eval(['{' xs ',' ys ',' zs '}']);
F=eval(f.F);
a=F(1,1,1);
epsilon=1e-10;  %Adjust when needed. Larger value = greater tolerance.
pc=1+epsilon;
nc=1-epsilon;
if 0<a
   c1=nc;c2=pc;
else
   c1=pc;c2=nc;
end
y=sum(sum(sum(a*c1-eps<=F & F<=a*c2+eps)))==prod(size(F));