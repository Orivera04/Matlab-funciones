function tube(xy,ab,rtr,pq,box,vue)
%TUBE	Generating function for Edward's parametric curves.
%	tube(xy,ab,rtr,pq)) takes the following arguments:
%
%	xy = string name of function  [xt,yt] = xy(t)
%     	     defining parametric curve to be revolved
%	ab = [a b] = interval of defn of parametric curve
%	rtr = [radius twist revs] for revolution of curve
%	pq = [p q] = numbers of t- and u-subintervals
%	box = [x1 x2 y1 y2 z1 z2]  for viewing tube

%       C. Henry Edwards, University of Georgia. 6-20-93.
%
%	Copyright (c) 1984-94 by The MathWorks, Inc.

a = ab(1);   b = ab(2);
p = pq(1);   q = pq(2);
h = (b-a)/p;
t = a : h : b;

radius = rtr(1);
twist  = rtr(2);
revs   = rtr(3);

k = 2*revs*pi/q;
u = 0 : k : 2*revs*pi;

[tt,uu] = meshgrid(t,u);

xx = (radius + xpr(xy, tt, twist*uu)).*cos(uu);
yy = (radius + xpr(xy, tt, twist*uu)).*sin(uu);
zz = xpz(xy, tt, twist*uu);

surf(xx,yy,zz)
axis(box)
axis('off')
if nargin > 5 
   view(vue)
   end
