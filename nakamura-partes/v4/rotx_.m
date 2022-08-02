% rotx_(x,y,z,th) rotates a vector [x,y,z] 
% th degrees counter-clockwise about
% the x-axis.  See Appendix B; List B.1.
function [xd,yd,zd]=rotx_(x,y,z,th)
cosf=cos(th*pi/180);sinf=sin(th*pi/180);
xd =x; 
yd =  cosf.*y - sinf.*z;
zd =  sinf.*y + cosf.*z;
 
