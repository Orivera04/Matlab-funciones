function [result]=vertria(b,h,p,req)
%VERTRIA Horizontal triangle shape routine.
%   VERTRIA(BASE,HEIGHT,P,REQUEST) 
%
%   Shape described: Triangle with a verizontal base.
%
%   Datum location: Leftmost point of base.
%
%   Input arguments:
%     BASE: Length of base (base must be a horizontal line).
%     HEIGHT: Vertical distance between base and vertex may be negative.
%     P: Horizontal distance from the datum to lower edge of small edge. May
%       be negative.
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
%   See also CHANNEL, CIRCLE, COMP, HALFCIRCLE, HORTRAP, IBEAM, LBEAM,
%      OBEAM, QUARTERCIRCLE, RECTANGL, RECTUBE, TBEAM, VERTRAP. 

%   Details are to be found in Mastering Mechanics I, Douglas W. Hull,
%   Prentice Hall, 1998

%   Douglas W. Hull, 1998
%   Copyright (c) 1998-99 by Prentice Hall
%   Version 1.00

req=lower(req);

origH=h;
h=abs(h);
if b<0
  disp ('Base must be a positive length')
  return
end

if     strcmp(req,'area')  result=b*h/2;
elseif strcmp(req,'circ')  result=sqrt(h^2+p^2)+sqrt(h^2+(b-p)^2)+b;
elseif strcmp(req,'iy')    result=b*h^3/36;
elseif strcmp(req,'ix')
  if p==0 | p==b % right triangle
    result=h*b^3/36;
  end
  if p<0 % vertex extends below base
    midh=b*h/(abs(p)+b);
    lsi=hortria(midh,p,h,'ix');
    lsa=hortria(midh,p,h,'area');
    lsd=hortria(midh,p,h,'centy');
    usi=hortria(midh,b,0,'ix');
    usa=hortria(midh,b,0,'area');
    usd=hortria(midh,b,0,'centy');
    centroid=vertria(b,h,p,'centy');
    result=lsi+lsa*(centroid-lsd)^2+usi+usa*(centroid-usd)^2;
  end
  if p>b % vertex extends above base
    midh=b*h/p;
    lsi=hortria(midh,-b,0,'ix');
    lsa=hortria(midh,-b,0,'area');
    lsd=hortria(midh,-b,0,'centy')+b;
    usi=hortria(midh,p-b,h,'ix');
    usa=hortria(midh,p-b,h,'area');
    usd=hortria(midh,p-b,h,'centy')+b;
    centroid=vertria(b,h,p,'centy');
    result=lsi+lsa*(centroid-lsd)^2+usi+usa*(centroid-usd)^2;
  end
  if p>0 & p<b % vertex is across from the base	       
    lsi=hortria(h,-p,0,'ix');
    lsa=hortria(h,-p,0,'area');
    lsd=hortria(h,-p,0,'centy')+p;
    usi=hortria(h,b-p,0,'ix');
    usa=hortria(h,b-p,0,'area');
    usd=hortria(h,b-p,0,'centy')+p;
    centroid=vertria(b,h,p,'centy');
    result=lsi+lsa*(centroid-lsd)^2+usi+usa*(centroid-usd)^2;
  end

elseif strcmp(req,'centy') 
  if p<0 % vertex extends below base
    midh=b*h/(abs(p)+b);
    lsa=hortria(midh,p,h,'area');
    lsd=hortria(midh,p,h,'centy');
    usa=hortria(midh,b,0,'area');
    usd=hortria(midh,b,0,'centy');
    wa=vertria(b,h,p,'area');
    result=((lsa*lsd)+(usa*usd))/wa;
  end
  if p==0 % right triangle
    result=b/3;
  end
  if p==b % right triangle
    result=b*2/3;
  end
  if p>b % vertex extends above base
    midh=b*h/p;
    lsa=hortria(midh,-b,0,'area');
    lsd=hortria(midh,-b,0,'centy')+b;
    usa=hortria(midh,p-b,h,'area');
    usd=hortria(midh,p-b,h,'centy')+b;
    wa=vertria(b,h,p,'area');
    result=((lsa*lsd)+(usa*usd))/wa;
  end
  if p>0 & p<b % vertex is across from the base
    lsa=hortria(h,-p,0,'area');
    lsd=hortria(h,-p,0,'centy')+p;
    usa=hortria(h,b-p,0,'area');
    usd=hortria(h,b-p,0,'centy')+p;
    wa=vertria(b,h,p,'area');
    result=((lsa*lsd)+(usa*usd))/wa;
  end
elseif strcmp(req,'centx') 
  result=origH/3;	
elseif strcmp(req,'comp') 
  result(1,1)=vertria(b,origH,p,'area');
  result(1,2)=vertria(b,origH,p,'circ');
  result(1,3)=vertria(b,origH,p,'centx');
  result(1,4)=vertria(b,origH,p,'centy');
  result(1,5)=vertria(b,origH,p,'ix');
  result(1,6)=vertria(b,origH,p,'iy');
elseif strcmp(req,'draw')
  xcentroid=vertria(b,origH,p,'centx');
  ycentroid=vertria(b,origH,p,'centy');
  X=[0 origH 0 0];
  Y=[0 p b 0];
  fill(X,Y,'r')
  hold on;
  ColA=strvcat('Area','Circumference','Centroid X','Centroid Y','Ix','Iy');
  ColB=makecol(vertria(b,origH,p,'comp')');
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
