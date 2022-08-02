function [xx,yy]=arrowh(start,stop,scale)  
%  ARROWH  Determine data so that you can draw a line 
%          with an arrow pointing from start to stop.
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


