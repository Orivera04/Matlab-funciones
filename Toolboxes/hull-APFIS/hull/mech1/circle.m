function [result]=circle(r,req)
%CIRCLE Circle shape routine.
%   CIRCLE(RADIUS, REQUEST) 
%
%   Shape described: Circle.
%
%   Datum location: Center.
%
%   Input arguments:
%     radius: Radius of circle.
%
%   Requests: (Must be in single quotes)
%     'area':  Area of the shape.
%     'circ':  Circumference of shape.
%     'Ix':    Area moment of inertia about the neutral x axis.
%     'Iy':    Area moment of inertia about the neutral y axis.
%     'centX': Distance from datum to centroid in the x direction.
%     'centY': Distance from datum to centroid in the y direction.
%     'J':     Polar moment of inertia.
%     'comp':  All of the above in a 1x6 matrix.
%     'draw':  Show the shape graphically.
%
%   See also CIRCLE, COMP, HALFCIRCLE, HORTRAP, HORTRIA, IBEAM, LBEAM, 
%      OBEAM, QUARTERCIRCLE, RECTANGL, RECTUBE, TBEAM, VERTRAP, VERTRIA.  

%   Details are to be found in Mastering Mechanics I, Douglas W. Hull,
%   Prentice Hall, 1998

%   Douglas W. Hull, 1998
%   Copyright (c) 1998-99 by Prentice Hall
%   Version 1.00

req=lower(req);

if     strcmp(req,'area')  result=pi*r.^2;
elseif strcmp(req,'circ')  result=2*pi*r;
elseif strcmp(req,'ix')    result=r.^4*pi/4;
elseif strcmp(req,'iy')    result=r.^4*pi/4;
elseif strcmp(req,'centx') result=0;
elseif strcmp(req,'centy') result=0;
elseif strcmp(req,'j')     result=pi/2*r.^4;
elseif strcmp(req,'comp') 
  result(1,1)=circle(r,'area');
  result(1,2)=circle(r,'circ');
  result(1,3)=circle(r,'centx');
  result(1,4)=circle(r,'centx');
  result(1,5)=circle(r,'ix');
  result(1,6)=circle(r,'iy');
elseif strcmp(req,'draw')
  xcentroid=circle(r,'centx');
  ycentroid=circle(r,'centy');
  angle =[0: DR(1): DR(360)];
  X=r*cos(angle);
  Y=r*sin(angle);
  fill(X,Y,'r')
  hold on
  ColA=strvcat('Area','Circumference','Centroid X','Centroid Y','Ix','Iy');
  ColB=makecol(circle(r,'comp')');
  plot (xcentroid,ycentroid,'ko',0,0,'g*')
  hold off;
  axis ('equal')
  titleblock(ColA,ColB)
  expandaxis(5,5,5,0)
else
  disp ('That is not a valid request, try area, circ, Ix, Iy, centX,')
  disp ('centY, comp.')
  disp ('You must use single quotes')
end

