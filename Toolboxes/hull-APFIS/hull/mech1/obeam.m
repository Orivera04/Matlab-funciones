function [result]=obeam(od,id,req)
%OBEAM Circular tube shape routine.
%   OBEAM(OD,ID,REQUEST) 
%
%   Shape described: Circular tube.
%
%   Datum location: Center.
%
%   Input arguments:
%     OD: Outer diameter.
%     ID: Inner diameter.   
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
%   See also CHANNEL, CIRCLE, COMP, HALFCIRCLE, HORTRAP, HORTRIA, IBEAM,
%      LBEAM, QUARTERCIRCLE, RECTANGL, RECTUBE, TBEAM, VERTRAP, VERTRIA.

%   Details are to be found in Mastering Mechanics I, Douglas W. Hull,
%   Prentice Hall, 1998

%   Douglas W. Hull, 1998
%   Copyright (c) 1998-99 by Prentice Hall
%   Version 1.00

req=lower(req);

if (id >= od)
  disp ('The inner diameter must be smaller than the outer diameter')
  return
end
% breaks up the tube into two circles to be used in the
% comp shape routine.
part(1,:)=[circle(od/2,'comp'),0,0,1];
part(2,:)=[circle(id/2,'comp'),0,0,-1]; %the hole
if     strcmp(req,'area')  result=comp(part,'area');
elseif strcmp(req,'circ')  result=comp(part,'circ');
elseif strcmp(req,'Ix')  result=comp(part,'ix');
elseif strcmp(req,'Iy')  result=comp(part,'iy');   
elseif strcmp(req,'centx')  result=comp(part,'centx');
elseif strcmp(req,'centy')  result=comp(part,'centy');
elseif strcmp(req,'j')      result=pi/2*(od^4-id^4);
elseif strcmp(req,'comp') 
  result(1,1)=obeam(od,id,'area');
  result(1,2)=obeam(od,id,'circ');
  result(1,3)=obeam(od,id,'centx');
  result(1,4)=obeam(od,id,'centy');	
  result(1,5)=obeam(od,id,'ix');
  result(1,6)=obeam(od,id,'iy');
elseif strcmp(req,'draw')
  xcentroid=obeam(od,id,'centx');
  ycentroid=obeam(od,id,'centy');
  angle =[0: DR(1): DR(360)];
  X=[id/2*cos(angle) od/2*cos(angle)];
  Y=[id/2*sin(angle) od/2*sin(angle)];
  fill(X,Y,'r')
  hold on
  ColA=strvcat('Area','Circumference','Centroid X','Centroid Y','Ix','Iy');
  ColB=makecol(obeam(od,id,'comp')');
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
