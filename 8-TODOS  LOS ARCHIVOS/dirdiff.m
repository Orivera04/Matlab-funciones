function Xpf = dirdiff(X,f,p)

% Xpf = dirdiff(X,f,p) 
% generates directional derivative of symbolic scalar function f 
% at the point p in the direction of symbolic vector X(p). 
% p must be a cell array {p1,p2,..pn} of doubles or symbolic variables.
%examples 
% syms x1 x2 x3 y1 y2 y3
% X = [ 2*x3 - x1^2 ; x1^3 - x3^2 ; x2^4 ] ;
% f = x1^2 + x2^2 + x3^2 ;
% dirdiff(X,f,{2,0,3}) returns Xpf = 3.5777
% dirdiff(X,f,{y1,0,0}) returns Xpf = -2*y1^3/(y1^4+y1^6)^(1/2)

% Mukhtar Ullah
% mukhtar.ullah@informatik.uni-rostock.de
% September 3, 2004


x = sym(findsym(X));
X = subs(X(:),x,p);
if isnumeric(p)
    normX = norm(X);
else
    normX = sqrt(X.'*X);
end
X = X/normX;
gradf = jacobian(f, x).';
gradf = subs(gradf,x,p);
Xpf = X.'*gradf;