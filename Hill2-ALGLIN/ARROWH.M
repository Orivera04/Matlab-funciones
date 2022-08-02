function [xx,yy]=arrowh(start,stop,scale)  %last updated 1/24/96
%  ARROWH  Determine data so that you can draw a line 
%          with an arrow pointing from start to stop.
%
%          Use in the form ==>  [xx,yy]=arrowh(start,stop,scale)  <==
%
%              start is the x,y point where the line starts
%              stop is the x,y point where the line stops
%              scale is an optional argument that will 
%                     scale the size of the arrow tips
%          Using plot(xx,yy) in the calling routine draws the vector.
%
%  By: David R. Hill, MATH Department, Temple University
%      Philadelphia, Pa., 19122        Email: hill@math.temple.edu

%  This routine is derived from arrow2.m by
%       8/4/93    Jeffery Faneuff
%       Copyright (c) 1988-93 by the MathWorks, Inc.

if nargin==2
  xl = get(gca,'xlim');
  yl = get(gca,'ylim');
  xd = xl(2)-xl(1);        % this sets the scale for the arrow size
  yd = yl(2)-yl(1);        % thus enabling the arrow to appear in correct 
  scale = (xd + yd) / 2;   % proportion to the current axis
end

xdif = stop(1) - start(1);
ydif = stop(2) - start(2);

theta = atan(ydif/xdif);  % the angle has to point according to the slope

if(xdif>=0)
  scale = -scale;
end

xx = [start(1), stop(1),(stop(1)+0.02*scale*cos(theta+pi/4)),NaN,stop(1),... 
(stop(1)+0.02*scale*cos(theta-pi/4))]';
yy = [start(2), stop(2), (stop(2)+0.02*scale*sin(theta+pi/4)),NaN,stop(2),... 
(stop(2)+0.02*scale*sin(theta-pi/4))]';


