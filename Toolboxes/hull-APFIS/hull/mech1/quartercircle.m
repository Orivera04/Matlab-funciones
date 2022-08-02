function [result]=quartercirc(r,orient,req)
%QUARTERCIRCLE Quarter circle shape routine.
%   QUARTERCIRCLE(radius,request) 
%
%   Shape described: Quarter circle.
%
%   Datum location: Center of circle.
%
%   Input arguments:
%     RADIUS: Radius of circle.
%
%   Requests: (Must be in single quotes)
%     'area':  Area of the shape.
%     'circ':  Circumference of shape.
%     'Ix':    Area moment of inertia about the neutral x axis.
%     'Iy':    Area moment of inertia about the neutral y axis.
%     'centX': Distance from datum to centroid in the x direction.
%     'centY': Distance from datum to centroid in the y direction.
%     'comp':  All of the above in a 1x6 matrix.
%     'draw':  Show the shape graphically.
%
%   See also CHANNEL, CIRCLE, COMP, HALFCIRCLE, HORTRAP, HORTRIA, IBEAM,
%      LBEAM, OBEAM, RECTANGL, RECTUBE, TBEAM, VERTRAP, VERTRIA. 

%   Details are to be found in Mastering Mechanics I, Douglas W. Hull,
%   Prentice Hall, 1998

%   Douglas W. Hull, 1998
%   Copyright (c) 1998-99 by Prentice Hall
%   Version 1.00

req=lower(req);
orient=lower(orient);

if     strcmp(req,'area')  result=(pi*r^2)/4;
elseif strcmp(req,'circ')  result=(2*pi*r)/4+2*r;
elseif strcmp(req,'ix')    result=r^4*pi/16;
elseif strcmp(req,'iy')    result=r^4*pi/16;
elseif strcmp(req,'centx')
  if strcmp(orient,'nw') | strcmp(orient,'sw')
     result=-4*r/(3*pi);
  else
     result=4*r/(3*pi);
  end
elseif strcmp(req,'centy')
  if strcmp(orient,'se') | strcmp(orient,'sw')
     result=-4*r/(3*pi);
  else
     result=4*r/(3*pi);
  end
elseif strcmp(req,'comp') 
  result(1,1)=quartercircle(r,orient,'area');
  result(1,2)=quartercircle(r,orient,'circ');
  result(1,3)=quartercircle(r,orient,'centx');
  result(1,4)=quartercircle(r,orient,'centx');	
  result(1,5)=quartercircle(r,orient,'ix');
  result(1,6)=quartercircle(r,orient,'iy');
elseif strcmp(req,'draw')
  if strcmp(orient,'ne')
    angle =[0: DR(1): DR(90)];
  elseif strcmp(orient,'se')
    angle =[DR(-90): DR(1): DR(0)];
  elseif strcmp(orient,'sw')
    angle =[DR(180): DR(1): DR(270)];
  else strcmp(orient,'nw')
    angle =[DR(90): DR(1): DR(180)];
  end
  xcentroid=quartercircle(r,orient,'centx');
  ycentroid=quartercircle(r,orient,'centy');
  X=[0, r*cos(angle), 0];
  Y=[0, r*sin(angle), 0];
  fill(X,Y,'r')
  hold on
  ColA=strvcat('Area','Circumference','Centroid X','Centroid Y','Ix','Iy');
  ColB=makecol(quartercircle(r,orient,'comp')');
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

