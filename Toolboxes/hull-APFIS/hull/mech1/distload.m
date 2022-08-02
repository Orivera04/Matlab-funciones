function [force, placement]=distload(ho,ht,x)
%DISTLOAD Converts a linearly distributed load to a point force.
%   [FORCE, PLACEMENT]=DISTLOAD(H1,H2,X) Given the two magnitudes H1 and H2 
%   that a linearly distributed load varies between, and the length of 
%   application, the routine will find the magnitude and location of the 
%   equivalent force.
%
%   See also DEG2XY, DIST2X, DIST2Y, RAD2XY, RISE2XY, XY2DEG, XY2RAD.   

%   Details are to be found in Mastering Mechanics I, Douglas W. Hull,
%   Prentice Hall, 1998

%   Douglas W. Hull, 1998
%   Copyright (c) 1998-99 by Prentice Hall
%   Version 1.00

if ho >= ht %left side is bigger
  force = vertrap(ho,x,ht,(ho-ht),'area'); % find area
  placement = vertrap(ho,x,ht,(ho-ht),'centX'); % find centroid
else %right side is bigger
  force = vertrap(ht,(-x),ho,(ht-ho),'area'); % find area
  placement = x + (vertrap(ht,(-x),ho,(ht-ho),'centX')); % find centroid
end
