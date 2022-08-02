function [result]=channel(b,h,bt,lt,orient,req)
%CHANNEL U-shape shape routine.
%   CHANNEL(BASE,HEIGHT,BT,LT,ORIENT,REQUEST) 
%
%   Shape described: A U-shaped channel.
%
%   Datum location: Bottom left corner.
%
%   Input arguments:
%     BASE: Distance between the vertical sides.
%     HEIGHT: Distance between the horizontal sides.
%     BT: Base thickness.
%     LT: Leg thickness.
%     ORIENT: Either 'n','e','s', or 'w'.
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
%   See also CIRCLE, COMP, HALFCIRCLE, HORTRAP, HORTRIA, IBEAM, LBEAM,
%     OBEAM, QUARTERCIRCLE, RECTANGL, RECTUBE, TBEAM, VERTRAP, VERTRIA.  

%   Details are to be found in Mastering Mechanics I, Douglas W. Hull,
%   Prentice Hall, 1998

%   Douglas W. Hull, 1998
%   Copyright (c) 1998-99 by Prentice Hall
%   Version 1.00

req=lower(req);
orient=lower(orient);

if (bt >= h)
  disp ('The height must be greater than the base thickness')
  return
end
if (lt*2 >= b)
  disp ('The base must be bigger than twice the leg thickness')
  return
end
% breaks up the channel into two rectangles to be used in the
% comp shape routine.
part(1,:)=[rectangle(b,h,'comp'),0,0,1];
part(2,:)=[rectangle((b-2*lt),(h-bt),'comp'),lt,bt,-1]; %the hole
if     strcmp(req,'area')  result=comp(part,'area');
elseif strcmp(req,'circ')  result=comp(part,'circ')-(2*(b-2*lt));
elseif strcmp(req,'ix') 
  if strcmp(orient,'e')  result=comp(part,'iy');
  elseif strcmp(orient,'s')  result=comp(part,'ix');
  elseif strcmp(orient,'w')  result=comp(part,'iy');
  else  result=comp(part,'ix');
  end
elseif strcmp(req,'iy')
  if strcmp(orient,'e')  result=comp(part,'ix');
  elseif strcmp(orient,'s')  result=comp(part,'iy');
  elseif strcmp(orient,'w')  result=comp(part,'ix');
  else  result=comp(part,'iy');   
  end
elseif strcmp(req,'centx')
  if strcmp(orient,'e')  result=comp(part,'centy');
  elseif strcmp(orient,'s')  result=comp(part,'centx');
  elseif strcmp(orient,'w')  result=h-comp(part,'centy');
  else  result=comp(part,'centx');
  end
elseif strcmp(req,'centy')
  if strcmp(orient,'e')  result=comp(part,'centx');
  elseif strcmp(orient,'s')  result=h-comp(part,'centy');
  elseif strcmp(orient,'w')  result=comp(part,'centx');
  else  result=comp(part,'centy');
  end
elseif strcmp(req,'comp') 
  result(1,1)=channel(b,h,bt,lt,orient,'area');
  result(1,2)=channel(b,h,bt,lt,orient,'circ');
  result(1,3)=channel(b,h,bt,lt,orient,'centx');
  result(1,4)=channel(b,h,bt,lt,orient,'centy');	
  result(1,5)=channel(b,h,bt,lt,orient,'ix');
  result(1,6)=channel(b,h,bt,lt,orient,'iy');
elseif strcmp(req,'draw')
  xcentroid=channel(b,h,bt,lt,orient,'centx');
  ycentroid=channel(b,h,bt,lt,orient,'centy');
  X=[0 b b (b-lt) (b-lt) lt lt 0 0];
  Y=[0 0 h h bt bt h h 0];
  if strcmp(orient,'n')
    fill(X,Y,'r')
  elseif strcmp(orient,'e')
    fill(Y,X,'r')
  elseif strcmp(orient,'s')
    fill(X,h-Y,'r')
  else
    fill(h-Y,X,'r')
  end
  hold on;
  ColA=strvcat('Area','Circumference','Centroid X','Centroid Y','Ix','Iy');
  ColB=makecol(channel(b,h,bt,lt,orient,'comp')');
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
