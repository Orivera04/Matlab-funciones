function [result]=halfcircle(r,orient,req)
%HALFCIRCLE Semicircle shape routine.
%   HALFCIRCLE(RADIUS,ORIENT,REQUEST) 
%
%   Shape described: A semi-circle.
%
%   Datum location: Center of circle.
%
%   Input arguments:
%     RADIUS: Radius of circle.
%     ORIENTATION: Either 'n','e','s', or 'w'.  
%
%   Requests: (Must be in single quotes)
%     'area':  Area of the shape.
%     'circ':  Circumference of shape.
%     'Ix':    Area moment of inertia about the neutral x axis.
%     'Iy':    Area moment of inertia about the neutral y axis.
%     'centX': Distance from datum to centroid in the x direction.
%     'centY': Distance from datum to centroid in the y direction.
%     'comp':  All of the above in a 1x6 matrix.
%
%   See also CHANNEL, CIRCLE, COMP, HORTRAP, HORTRIA, IBEAM, LBEAM,
%      OBEAM, QUARTERCIRCLE, RECTANGL, RECTUBE, TBEAM, VERTRAP, VERTRIA. 

%   Details are to be found in Mastering Mechanics I, Douglas W. Hull,
%   Prentice Hall, 1998

%   Douglas W. Hull, 1998
%   Copyright (c) 1998-99 by Prentice Hall
%   Version 1.00

req=lower(req);
orient=lower(orient);

if     strcmp(req,'area')  result=(pi*r^2)/2;
elseif strcmp(req,'circ')  result=(2*pi*r)/2+2*r;
elseif strcmp(req,'ix')    result=r^4*pi/8;
elseif strcmp(req,'iy')    result=r^4*pi/8;
elseif strcmp(req,'centx') 
  if strcmp(orient,'w') result=-4*r/(3*pi);
  elseif strcmp(orient,'n') | strcmp(orient,'s')
     result=0;
  else
     result=4*r/(3*pi);
  end
elseif strcmp(req,'centy')
 if strcmp(orient,'s') result=-4*r/(3*pi);
  elseif strcmp(orient,'e') | strcmp(orient,'w')
     result=0;
  else
     result=4*r/(3*pi);
  end
elseif strcmp(req,'comp') 
  result(1,1)=halfcircle(r,orient,'area');
  result(1,2)=halfcircle(r,orient,'circ');
  result(1,3)=halfcircle(r,orient,'centx');
  result(1,4)=halfcircle(r,orient,'centy');
  result(1,5)=halfcircle(r,orient,'ix');
  result(1,6)=halfcircle(r,orient,'iy');
elseif strcmp(req,'draw')
  if strcmp(orient,'n')
    angle =[0: DR(1): DR(180)];
  elseif strcmp(orient,'e')
    angle =[DR(-90): DR(1): DR(90)];
  elseif strcmp(orient,'s')
    angle =[DR(180): DR(1): DR(360)];
  else strcmp(orient,'w')
    angle =[DR(90): DR(1): DR(270)];
  end
  xcentroid=halfcircle(r,orient,'centx');
  ycentroid=halfcircle(r,orient,'centy');
  X=r*cos(angle);
  Y=r*sin(angle);
  fill(X,Y,'r');
  hold on
  ColA=strvcat('Area','Circumference','Centroid X','Centroid Y','Ix','Iy');
  ColB=makecol(halfcircle(r,orient,'comp')');
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
