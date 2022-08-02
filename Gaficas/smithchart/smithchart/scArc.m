%scArc : Draws an arc (a circle) on the smith chart passing through a given point
%
%  SYNOPSIS:
%     Draws an arc (a circle) on the smith chart passing through a given point.
%     the point in question is defined as an (r,x) pair. This function should only
%     be called when a smith chart figure is already present.
%
%     See also scDraw, scInv, scMove, scMatchCirc
%     
%  SYNTAX:
%     scArc(Point, LinCol)
%
%  INPUT ARGUMENTS:
%     Point  : values of r and x defining a point on the smith chart as a vector [r x]
%     LinCol : color of the arc (or circle)
%
%  OUTPUT ARGUMENT:
%     none
%
%
%     Mohammad Ashfaq - (31-05-2000)  mohammad.ashfaq@ruhr-uni-bochum.de
%     Copyright (c) 2000 by the Chair for High-Frequency Engineering
%     Ruhr-University Bochum, Germany. 
%

 function scArc(Point, LinCol)

 r1 = Point(1);
 x1 = Point(2);

 %x2 = to(2);
 %r2 = to(1);

 [u1, v1] = scPOI(r1, x1);
 %[u2,v2]=point_of_intersection(r2,x2);
 x = linspace(-sqrt(u1^2+v1^2),sqrt(u1^2+v1^2),500);
 
 plot(x,sqrt(u1^2+v1^2-x.^2),LinCol);
 plot(x,-sqrt(u1^2+v1^2-x.^2),LinCol);

 % MARK POINT
 plot(u1,v1,'r*')

