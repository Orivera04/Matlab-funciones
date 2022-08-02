function [result]=ibeam(b,h,bt,wt,orient,req)
%IBEAM I-beam shape routine.
%   IBEAM(BASE,HEIGHT,BT,WT,ORIENT,REQUEST) 
%
%   Shape described: I-beam.
%
%   Datum location: Bottom left corner.
%
%   Input arguments:
%     BASE: Distance between the vertical sides.
%     HEIGHT: Distance between the horizontal sides.
%     BT: Base thickness.
%     WT: Web thickness.
%     ORIENT: Either 'I' or 'H'.
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
%   See also CHANNEL, CIRCLE, COMP, HALFCIRCLE, HORTRAP, HORTRIA, LBEAM,
%      OBEAM, QUARTERCIRCLE, RECTANGL, RECTUBE, TBEAM, VERTRAP, VERTRIA. 
%   Details are to be found in Mastering Mechanics I, Douglas W. Hull,
%   Prentice Hall, 1998

%   Douglas W. Hull, 1998
%   Copyright (c) 1998-99 by Prentice Hall
%   Version 1.00

req=lower(req);
orient=upper(orient);

if (2*bt >= h)
  disp ('The height must be greater than twice the base thickness')
  return
end
if (wt >= b)
  disp ('The base must be bigger than the web thickness')
  return
end

if ~(strcmp(orient,'I') | strcmp(orient,'H'))
  disp ('Improper orientation')
  return
end

% breaks up the channel into two rectangles to be used in the
% comp shape routine.
part(1,:)=[rectangl(b,bt,'comp'),0,0,1];
part(2,:)=[rectangl(b,bt,'comp'),0,h-bt,1];
part(3,:)=[rectangl(wt,(h-2*bt),'comp'),((b-wt)/2),bt,1];
if     strcmp(req,'area')  result=comp(part,'area');
elseif strcmp(req,'circ')  result=comp(part,'circ')- 4*wt;
elseif strcmp(req,'ix') 
  if strcmp(orient,'I')  result=comp(part,'ix');
  else  result=comp(part,'iy');
  end
elseif strcmp(req,'iy')
  if strcmp(orient,'I')  result=comp(part,'iy');
  else  result=comp(part,'Ix');
  end
elseif strcmp(req,'centx')
  if strcmp(orient,'I')  result=comp(part,'centx');
  else  result=comp(part,'centy');
  end
elseif strcmp(req,'centy')
  if strcmp(orient,'I')  result=comp(part,'centy');
  else  result=comp(part,'centX');
  end
elseif strcmp(req,'comp') 
  result(1,1)=ibeam(b,h,bt,wt,orient,'area');
  result(1,2)=ibeam(b,h,bt,wt,orient,'circ');
  result(1,3)=ibeam(b,h,bt,wt,orient,'centx');
  result(1,4)=ibeam(b,h,bt,wt,orient,'centy');	
  result(1,5)=ibeam(b,h,bt,wt,orient,'ix');
  result(1,6)=ibeam(b,h,bt,wt,orient,'iy');
elseif strcmp(req,'draw')
  xcentroid=ibeam(b,h,bt,wt,orient,'centx');
  ycentroid=ibeam(b,h,bt,wt,orient,'centy');
  X=[0 b b  (b+wt)/2  (b+wt)/2 b    b 0 0    (b-wt)/2 (b-wt)/2 0  0];
  Y=[0 0 bt bt        h-bt     h-bt h h h-bt h-bt     bt       bt 0];
  if strcmp(orient,'I')
    fill(X,Y,'r')
  else
    fill(Y,X,'r')
  end
  hold on;
  ColA=strvcat('Area','Circumference','Centroid X','Centroid Y','Ix','Iy');
  ColB=makecol(ibeam(b,h,bt,wt,orient,'comp')');
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
