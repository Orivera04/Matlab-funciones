function [result]=rectangle(b,h,req)
%RECTANGLE Rectangular shape routine.
%   [result]=VERTRAP(BASE,HEIGHT,REQUEST) 
%
%   Shape described: A rectangle.
%
%   Datum location: Bottom left corner.
%
%   Input arguments:
%     base: Distance between the vertical sides.
%     height: Distance between the horizontal sides.
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
%      LBEAM, OBEAM, QUARTERCIRCLE, RECTUBE, TBEAM, VERTRAP, VERTRIA.

%   Details are to be found in Mastering Mechanics I, Douglas W. Hull,
%   Prentice Hall, 1998

%   Douglas W. Hull, 1998
%   Copyright (c) 1998-99 by Prentice Hall
%   Version 1.00

req=lower(req);

if     strcmp(req,'area')  result=b*h;
elseif strcmp(req,'circ')  result=2*(b+h);
elseif strcmp(req,'ix')    result=b*h^3/12;
elseif strcmp(req,'iy')    result=h*b^3/12;
elseif strcmp(req,'centx') result=b/2;
elseif strcmp(req,'centy') result=h/2;
elseif strcmp(req,'comp') 
  result(1,1)=rectangle(b,h,'area');
  result(1,2)=rectangle(b,h,'circ');
  result(1,3)=rectangle(b,h,'centx');
  result(1,4)=rectangle(b,h,'centy');
  result(1,5)=rectangle(b,h,'ix');
  result(1,6)=rectangle(b,h,'iy');
elseif strcmp(req,'draw')
  xcentroid=rectangle(b,h,'centx');
  ycentroid=rectangle(b,h,'centy');
  X=[0 b b 0 0];
  Y=[0 0 h h 0];
  fill(X,Y,'r')
  hold on;
  ColA=strvcat('Area','Circumference','Centroid X','Centroid Y','Ix','Iy');
  ColB=makecol(rectangle(b,h,'comp')');
  plot (xcentroid,ycentroid,'ko',0,0,'g*')
  hold off
  axis ('equal') 
  titleblock(ColA,ColB)
  expandaxis(5,5,5,0) 
else 
  disp ('That is not a valid request, try area, circ, Ix, Iy, centX,')
  disp ('centY, comp.')
  disp ('You must use single quotes')
end

