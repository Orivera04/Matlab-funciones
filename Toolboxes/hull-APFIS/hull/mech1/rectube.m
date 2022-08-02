function [result]=rectube(ob,oh,ib,ih,req)
%RECTUBE Rectangular tube shape routine.
%   RECTUBE(OB,OH,IB,IH,REQUEST) 
%
%   Shape described: Rectangular tube.
%
%   Datum location: Bottom left corner.
%
%   Input arguments:
%     OB: Outer base dimension.
%     OH: Outer height dimension.
%     IB: Inner base dimension.
%     IH: Inner height dimension
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
%      LBEAM, OBEAM, QUARTERCIRCLE, RECTANGL, TBEAM, VERTRAP, VERTRIA. 

%   Details are to be found in Mastering Mechanics I, Douglas W. Hull,
%   Prentice Hall, 1998

%   Douglas W. Hull, 1998
%   Copyright (c) 1998-99 by Prentice Hall
%   Version 1.00

req=lower(req);

if (ib >= ob)
  disp ('The inner base must be smaller than the outer base')
  return
end
if (ih >= oh)
  disp ('The inner height must be smaller than the outer height')
  return
end
% breaks up the tube into two rectangles to be used in the
% comp shape routine.
part(1,:)=[rectangl(ob,oh,'comp'),0,0,1];
part(2,:)=[rectangl(ib,ih,'comp'),(ob-ib)/2,(oh-ih)/2,-1]; %the hole
if     strcmp(req,'area')  result=comp(part,'area');
elseif strcmp(req,'circ')  result=comp(part,'circ');
elseif strcmp(req,'ix')  result=comp(part,'ix');
elseif strcmp(req,'iy')  result=comp(part,'iy');   
elseif strcmp(req,'centx')  result=comp(part,'centx');
elseif strcmp(req,'centy')  result=comp(part,'centy');
elseif strcmp(req,'comp') 
  result(1,1)=rectube(ob,oh,ib,ih,'area');
  result(1,2)=rectube(ob,oh,ib,ih,'circ');
  result(1,3)=rectube(ob,oh,ib,ih,'centx');
  result(1,4)=rectube(ob,oh,ib,ih,'centy');	
  result(1,5)=rectube(ob,oh,ib,ih,'ix');
  result(1,6)=rectube(ob,oh,ib,ih,'iy');
elseif strcmp(req,'draw')
  xcentroid=rectube(ob,oh,ib,ih,'centx');
  ycentroid=rectube(ob,oh,ib,ih,'centy');
  X=[0 ob ob 0 0 (ob-ib)/2 (ob-ib)/2+ib (ob-ib)/2+ib (ob-ib)/2 (ob-ib)/2 0];
  Y=[0 0 oh oh 0 (oh-ih)/2 (oh-ih)/2 (oh-ih)/2+ih (oh-ih)/2+ih (oh-ih)/2 0];
  fill(X,Y,'r')
  hold on;
  ColA=strvcat('Area','Circumference','Centroid X','Centroid Y','Ix','Iy');
  ColB=makecol(rectube(ob,oh,ib,ih,'comp')');
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
