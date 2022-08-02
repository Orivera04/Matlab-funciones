function G=grad(S,name)
%GRAD  Gradient vector.
%   G = GRAD(S[,NAME]) returns the gradient field of a scalar function S.
%
%   See Also DIV, CURL, LAPL.

% Copyright (c) 2001-04-16, B. Rasmus Anthin.
% Revision 2002-12-06

error(nargchk(1,2,nargin))
if nargin==1
   name=inputname(1);
end
if isempty(name)
   name=S.f;
end
G=vector(S);
[h1 h2 h3]=coeffs(S);
[x y z]=vars(S);
G=[pdiff(S,1,1,name)/h1 ...
      pdiff(S,2,1,name)/h2 ...
      pdiff(S,3,1,name)/h3];
G=struct(G);
G.fx=['del.' x '(' name ')'];
G.fy=['del.' y '(' name ')'];
G.fz=['del.' z '(' name ')'];
G=vector(G);
