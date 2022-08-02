% rotz_(x,y,z,th) rotates a vector [x,y,z] 
% th degrees counter-clockwise about
% the z-axis.  See Appendix B; List B.1.
function [xd,yd,zd]=rotz_(x,y,z,phi)
cosf=cos(phi*pi/180);sinf=sin(phi*pi/180); 
xd =  cosf *x - sinf *y;
yd = sinf *x + cosf *y;
zd =z;
