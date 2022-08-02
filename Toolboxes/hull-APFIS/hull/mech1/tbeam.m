function [result]=tbeam(b,h,bt,wt,orient,req)
%TBEAM T-beam shape routine.
%   TBEAM(BASE,HEIGHT,BT,WT,ORIENT,REQUEST) 
%
%   Shape described: T-beam.
%
%   Datum location: Bottom left corner.
%
%   Input arguments:
%     BASE: Horizontal dimension.
%     HEIGHT: Verical dimension.
%     BT: Base thickness.
%     WT: Web thickness.
%     ORIENT: Either 'n','e','s' or 'w'.
%
%   Requests: (Must be in single quotes)
%     'area':  Area of the shape.
%     'circ':  Circumfrence of shape.
%     'Ix':    Area moment of inertia about the neutral x axis.
%     'Iy':    Area moment of inertia about the neutral y axis.
%     'centX': Distance from datum to centroid in the x direction.
%     'centY': Distance from datum to centroid in the y direction.
%     'comp':  All of the above in a 1x6 matrix.
%     'draw':  Show the shape graphically.
%
%   See also CHANNEL, CIRCLE, COMP, HALFCIRCLE, HORTRAP, HORTRIA, IBEAM,
%      LBEAM, OBEAM, QUARTERCIRCLE, RECTANGL, RECTUBE, VERTRAP, VERTRIA. 

%   Details are to be found in Mastering Mechanics I, Douglas W. Hull,
%   Prentice Hall, 1998

%   Douglas W. Hull, 1998
%   Copyright (c) 1998-99 by Prentice Hall
%   Version 1.00

req=lower(req);
orient=lower(orient);

if (bt >= h)
  disp ('The height must be greater than twice the base thickness')
  return
end
if (wt >= b)
  disp ('The base must be bigger than the web thickness')
  return
end
if ~(strcmp(orient,'n') | strcmp(orient,'e') | ... 
  strcmp(orient,'s') | strcmp(orient,'w'))
  disp('Invalid orientation')
  return
end
% breaks up the channel into two rectangles to be used in the
% comp shape routine.
part(1,:)=[rectangl(b,bt,'comp'),0,h-bt,1];
part(2,:)=[rectangl(wt,(h-bt),'comp'),((b-wt)/2),0,1];
if     strcmp(req,'area')  result=comp(part,'area');
elseif strcmp(req,'circ')  result=comp(part,'circ')- 2*wt;
elseif strcmp(req,'ix') 
  if strcmp(orient,'n') | strcmp(orient,'s') result=comp(part,'ix');
  else  result=comp(part,'iy');
  end
elseif strcmp(req,'iy')
  if strcmp(orient,'n') | strcmp(orient,'s') result=comp(part,'iy');
  else  result=comp(part,'ix');
  end
elseif strcmp(req,'centx')
  if strcmp(orient,'n') | strcmp(orient,'s') 
    result=comp(part,'centx');
  elseif strcmp(orient,'e')
    result=comp(part,'centy');
  else
    result=h-comp(part,'centy');
  end
elseif strcmp(req,'centy')
  if strcmp(orient,'n') 
    result=comp(part,'centy');
  elseif strcmp(orient,'s')
    result=h-comp(part,'centy')
  else  result=comp(part,'centx');
  end
elseif strcmp(req,'comp') 
  result(1,1)=tbeam(b,h,bt,wt,orient,'area');
  result(1,2)=tbeam(b,h,bt,wt,orient,'circ');
  result(1,3)=tbeam(b,h,bt,wt,orient,'centx');
  result(1,4)=tbeam(b,h,bt,wt,orient,'centy');	
  result(1,5)=tbeam(b,h,bt,wt,orient,'ix');
  result(1,6)=tbeam(b,h,bt,wt,orient,'iy');
elseif strcmp(req,'draw')
  xcentroid=tbeam(b,h,bt,wt,orient,'centx');
  ycentroid=tbeam(b,h,bt,wt,orient,'centy');
  X=[(b-wt)/2 (b+wt)/2 (b+wt)/2 b b 0 0 (b-wt)/2 (b-wt)/2];
  Y=[0 0 h-bt h-bt h h h-bt h-bt 0];
  if strcmp(orient,'n')
    fill(X,Y,'r')
  elseif strcmp(orient,'e')
    fill(Y,X,'r')
  elseif strcmp(orient,'s')
    fill(X,b-Y,'r')
  else
    fill(h-Y,X,'r')
  end
  hold on;
  ColA=strvcat('Area','Circumference','Centroid X','Centroid Y','Ix','Iy');
  ColB=makecol(tbeam(b,h,bt,wt,orient,'comp')');
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
