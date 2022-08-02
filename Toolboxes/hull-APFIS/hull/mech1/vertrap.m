function [result]=vertrap(b,h,a,p,req)
%VERTRAP Horizontal trapezoid shape routine.
%   VERTRAP(BASE,HEIGHT,A,P,REQUEST) 
%
%   Shape described: Trapezoid with a vertical base.
%
%   Datum location: Lowermost point of base.
%
%   Input arguments:
%     base: Length of base (base is the larger of the vertical sides).
%     height: Distance between the vertical sides, may be negative.
%     a: Length of the shorter of the vertical sides.
%     p: Vertical distance from the datum to lower edge of small edge.
%
%   Requests: (Must be in single quotes)
%     'area':  Area of the shape.
%     'circ':  CircumfERENce of shape.
%     'Ix':    Area moment of inertia about the neutral x axis.
%     'Iy':    Area moment of inertia about the neutral y axis.
%     'centX': Distance from datum to centroid in the x direction.
%     'centY': Distance from datum to centroid in the y direction.
%     'comp':  All of the above in a 1x6 matrix.
%     'draw':  Show the shape graphically.
%
%   See also CHANNEL, CIRCLE, COMP, HALFCIRCLE, HORTRAP, HORTRIA, IBEAM,
%      LBEAM, OBEAM, QUARTERCIRCLE, RECTANGL, RECTUBE, TBEAM, VERTRIA. 

%   Details are to be found in Mastering Mechanics I, Douglas W. Hull,
%   Prentice Hall, 1998

%   Douglas W. Hull, 1998
%   Copyright (c) 1998-99 by Prentice Hall
%   Version 1.00

req=lower(req);

if (a > b)
  disp ('"A" value may not be larger than "B" value.  Remember to use ')
  disp ('proper sign convention for "H"')
  return
end
if (p+a > b) | (p < 0)
  disp ('"A" side of trapezoid may not extend beyond the boundary ')
  disp ('of the base')
  return
end

Origh=h;
h=abs(h);
IsPos= (Origh==h)*2-1;
% breaks up the trapezoid into two triangles and a % rectangle to be used in
% the comp shape routine.
part(1,:)=[vertria(b-p-a,h,0,'comp'),0,(a+p),1];
part(2,:)=[rectangl(h,a,'comp'),0,p,1];
part(3,:)=[vertria(p,h,p,'comp'),0,0,1];

if     strcmp(req,'area')  result=h*(a+b)/2;
elseif strcmp(req,'circ')  result=sqrt(p^2+h^2)+a+sqrt(h^2+(b-a-p)^2)+b;
elseif strcmp(req,'ix')  result=comp(part,'ix');
elseif strcmp(req,'iy')  result=comp(part,'iy');   
elseif strcmp(req,'centx')  result=comp(part,'centx')*IsPos;
elseif strcmp(req,'centy')  result=comp(part,'centy');
elseif strcmp(req,'comp') 
  result(1,1)=vertrap(b,Origh,a,p,'area');
  result(1,2)=vertrap(b,Origh,a,p,'circ');
  result(1,3)=vertrap(b,Origh,a,p,'centx');
  result(1,4)=vertrap(b,Origh,a,p,'centx');	
  result(1,5)=vertrap(b,Origh,a,p,'ix');
  result(1,6)=vertrap(b,Origh,a,p,'iy');
elseif strcmp(req,'draw')
  xcentroid=vertrap(b,Origh,a,p,'centx');
  ycentroid=vertrap(b,Origh,a,p,'centy');
  X=[0 Origh Origh 0 0];
  Y=[0 p p+a b 0];
  fill(X,Y,'r')
  hold on;
  ColA=strvcat('Area','Circumference','Centroid X','Centroid Y','Ix','Iy');
  ColB=makecol(vertrap(b,Origh,a,p,'comp')');
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

