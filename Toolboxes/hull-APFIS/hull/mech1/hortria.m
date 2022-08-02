function [result]=hortria(b,h,p,req)
%HORTRIA Horizontal triangle shape routine.
%   HORTRIA(BASE,HEIGHT,P,REQUEST) 
%
%   Shape described: Triangle with a horizontal base.
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
%      OBEAM, QUARTERCIRCLE, RECTANGL, RECTUBE, TBEAM, VERTRAP, VERTRIA. 

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
elseif strcmp(req,'ix')    result=b*h^3/36;
elseif strcmp(req,'iy')
  if p==0 | p==b % right triangle
    result=h*b^3/36;
  end
  if p<0  % vertex extend past left edge of base.
    midh=b*h/(abs(p)+b);
    lsi=vertria(midh,p,h,'iy');
    lsa=vertria(midh,p,h,'area');
    lsd=vertria(midh,p,h,'centX');
    rsi=vertria(midh,b,0,'iy');
    rsa=vertria(midh,b,0,'area');
    rsd=vertria(midh,b,0,'centx');
    centroid=hortria(b,h,p,'centx');
    result=lsi+lsa*(centroid-lsd)^2+rsi+rsa*(centroid-rsd)^2;
  end
  if p>b  % vertex extend past right edge of base.
    midh=b*h/p;
    lsi=vertria(midh,-b,0,'iy');
    lsa=vertria(midh,-b,0,'area');
    lsd=vertria(midh,-b,0,'centx')+b;
    rsi=vertria(midh,p-b,h,'iy');
    rsa=vertria(midh,p-b,h,'area');
    rsd=vertria(midh,p-b,h,'centx')+b;
    centroid=hortria(b,h,p,'centx');
    result=lsi+lsa*(centroid-lsd)^2+rsi+rsa*(centroid-rsd)^2;
  end
  if p>0 & p<b % vertex is over the base	       
    lsi=vertria(h,-p,0,'iy');
    lsa=vertria(h,-p,0,'area');
    lsd=vertria(h,-p,0,'centx')+p;
    rsi=vertria(h,b-p,0,'iy');
    rsa=vertria(h,b-p,0,'area');
    rsd=vertria(h,b-p,0,'centx')+p;
    centroid=hortria(b,h,p,'centx');
    result=lsi+lsa*(centroid-lsd)^2+rsi+rsa*(centroid-rsd)^2;
  end

elseif strcmp(req,'centx') 
  if p<0  % vertex extend past left edge of base.
    midh=b*h/(abs(p)+b);
    lsa=vertria(midh,p,h,'area');
    lsd=vertria(midh,p,h,'centx');
    rsa=vertria(midh,b,0,'area');
    rsd=vertria(midh,b,0,'centx');
    wa=hortria(b,h,p,'area');
    result=((lsa*lsd)+(rsa*rsd))/wa;
  end
if p==0 % right triangle
  result=b/3;
end
if p==b % right triangle
  result=b*2/3;
end
if p>b  % vertex extend past right edge of base.
  midh=b*h/p;
  lsa=vertria(midh,-b,0,'area');
  lsd=vertria(midh,-b,0,'centx')+b;
  rsa=vertria(midh,p-b,h,'area');
  rsd=vertria(midh,p-b,h,'centx')+b;
  wa=hortria(b,h,p,'area');
  result=((lsa*lsd)+(rsa*rsd))/wa;
end
if p>0 & p<b % vertex is over the base
  lsa=vertria(h,-p,0,'area');
  lsd=vertria(h,-p,0,'centx')+p;
  rsa=vertria(h,b-p,0,'area');
  rsd=vertria(h,b-p,0,'centx')+p;
  wa=hortria(b,h,p,'area');
  result=((lsa*lsd)+(rsa*rsd))/wa;
end
elseif strcmp(req,'centy') 
  result=origH/3;
elseif strcmp(req,'comp') 
  result(1,1)=hortria(b,origH,p,'area');
  result(1,2)=hortria(b,origH,p,'circ');
  result(1,3)=hortria(b,origH,p,'centx');
  result(1,4)=hortria(b,origH,p,'centy');
  result(1,5)=hortria(b,origH,p,'ix');
  result(1,6)=hortria(b,origH,p,'iy');
elseif strcmp(req,'draw')
  xcentroid=hortria(b,origH,p,'centx');
  ycentroid=hortria(b,origH,p,'centy');
  X=[0 b p 0];
  Y=[0 0 origH 0];
  fill(X,Y,'r')
  hold on;
  ColA=strvcat('Area','Circumference','Centroid X','Centroid Y','Ix','Iy');
  ColB=makecol(hortria(b,origH,p,'comp')');
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

