% roty_(x,y,z,th) rotates a vector [x,y,z] 
% th degrees counter-clockwise about
% the y-axis.  See Appendix B; List B.1.
function [xd,yd,zd]=roty_(x,y,z,th)
cosf=cos(th*pi/180);sinf=sin(th*pi/180);
yd =y;
xd =  cosf.*x + sinf.*z;
zd = - sinf.*x + cosf.*z;

