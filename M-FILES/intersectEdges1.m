function point = intersectEdges1(s1,s2)
%INTERSECTEDGES return intersection pts. of 2 edges PQ,RS in 2D.
%   s1=[P(1),P(2),Q(1),Q(2)], s2=[R(1),R(2),S(1),S(2)].
%   P = intersectEdges1(s1, s2) returns the intersection point of
%   edges s1 and s2. s1 and s2 are [1*4] arrays of each edge  
%   s=([x1 y1 x2 y2]. See createEdge for details.  

% ensure input arrays are same size
N1 = size(s1, 1);N2 = size(s2, 1);tol = 1e-14;
if N1~=N2
    error('The input arrays are not same size')
end

% initialize result aray
x0 = zeros(N1, 1);y0 = zeros(N1, 1);

% indices of parallel lines and colinear lines:
par = abs(s1(3).*s2(4) - s2(3).*s1(4))<tol
col=abs((s2(1)-s1(1)).*s1(4)-(s2(2)-s1(2)).*s1(3))<tol & par
parnocol=par & ~col


x0(col) = Inf;y0(col) = Inf;x0(par & ~col) = NaN;y0(par & ~col) = NaN;

% process intersecting edges whose interecting lines intersect

i = ~par;
x1=s1(i,1);y1=s1(i,2);dx1=s1(i,3)-x1;dy1=s1(i,4)-y1;
x2=s2(i,1);y2=s2(i,2);dx2=s2(i,3)-x2;dy2=s2(i,4)-y2;

% compute intersection point
x0(i)=((y2-y1).*dx1.*dx2 + x1.*dy1.*dx2 - x2.*dy2.*dx1)./(dx2.*dy1-dx1.*dy2);
    
y0(i)=((x2-x1).*dy1.*dy2 + y1.*dx1.*dy2 - y2.*dx2.*dy1)./(dx1.*dy2-dx2.*dy1);
    
% compute position on each edge
t1=((y0(i)-y1)*dy1 + (x0(i)-x1)*dx1) / (dx1.*dx1+dy1.*dy1);
t2=((y0(i)-y2)*dy2 + (x0(i)-x2)*dx2) / (dx2.*dx2+dy2.*dy2);

% check points 
out = t1<-tol | t1>1+tol | t2<-tol | t2>1+tol;
x0(out) = NaN;y0(out) = NaN;

% format output arguments
point = [x0 y0];
