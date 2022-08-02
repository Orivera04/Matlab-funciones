function [result]=lbeam(hl,vl,ht,vt,orient,req)
%LBEAM L-beam shape routine.
%   LBEAM(BASE,HEIGHT,BT,VT,ORIENT,REQUEST) 
%
%   Shape described: L-beam.
%
%   Datum location: Outer corner.
%
%   Input arguments:
%     BASE: Distance between the vertical sides.
%     HEIGHT: Distance between the horizontal sides.
%     BT: Base thickness.
%     VT: Vertical thickness.
%     ORIENT: Either 'ne','se','sw', or 'nw'.
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
%      OBEAM, QUARTERCIRCLE, RECTANGL, RECTUBE, TBEAM, VERTRAP, VERTRIA.

%   Details are to be found in Mastering Mechanics I, Douglas W. Hull,
%   Prentice Hall, 1998

%   Douglas W. Hull, 1998
%   Copyright (c) 1998-99 by Prentice Hall
%   Version 1.00

req=lower(req);
orient=lower(orient);

if (ht < 0) | (vt < 0) | (hl < 0) | (vl < 0)
  disp ('None of the arguments may be negative')
  return
end
if (ht > vl) | (vt > hl)
  disp ('The thickness of one leg cannot be greater than the length')
  disp ('of the opposite leg')
  return
end

% breaks up the angle into two rectangles to be used in the
% comp shape routine.
part(1,:)=[rectangl(hl,ht,'comp'),0,0,1];
part(2,:)=[rectangl(vt,(vl-ht),'comp'),0,ht,1];
if     strcmp(req,'area')  result=comp(part,'area');
elseif strcmp(req,'circ')  result=2*(hl+vl);
elseif strcmp(req,'Ix')  result=comp(part,'ix');
elseif strcmp(req,'Iy')  result=comp(part,'iy');   
elseif strcmp(req,'centx')
  if strcmp(orient,'ne') | strcmp(orient,'se')
    result=(-1)*comp(part,'centx');
  else
    result=comp(part,'centx');
  end
elseif strcmp(req,'centy')
  if strcmp(orient,'ne') | strcmp(orient,'nw')
    result=(-1)*comp(part,'centY');
  else
    result=comp(part,'centy');
  end
elseif strcmp(req,'comp') 
  result(1,1)=lbeam(hl,vl,ht,vt,orient,'area');
  result(1,2)=lbeam(hl,vl,ht,vt,orient,'circ');
  result(1,3)=lbeam(hl,vl,ht,vt,orient,'centx');
  result(1,4)=lbeam(hl,vl,ht,vt,orient,'centy');	
  result(1,5)=lbeam(hl,vl,ht,vt,orient,'ix');
  result(1,6)=lbeam(hl,vl,ht,vt,orient,'iy');
elseif strcmp(req,'draw')
  xcentroid=lbeam(hl,vl,ht,vt,orient,'centx');
  ycentroid=lbeam(hl,vl,ht,vt,orient,'centy');
  X=[0 hl hl vt vt 0  0];
  Y=[0 0  ht ht vl vl 0];
  if strcmp(orient,'ne')
    fill(-X,-Y,'r')
  elseif strcmp(orient,'se')
    fill(-X,Y,'r')
  elseif strcmp(orient,'sw')
    fill(X,Y,'r')
  else
    fill(X,-Y,'r')
  end
  hold on;
  ColA=strvcat('Area','Circumference','Centroid X','Centroid Y','Ix','Iy');
  ColB=makecol(lbeam(hl,vl,ht,vt,orient,'comp')');
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
