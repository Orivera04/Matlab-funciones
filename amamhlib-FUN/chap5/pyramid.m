function [v,vr,vrr,h,area,n]=pyramid(r)
%
% [v,vr,vrr,h,area,n]=pyramid(r)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% This function determines geometrical 
% properties of a pyramid with the apex at the 
% origin and corner coordinates of the base 
% stored in the rows of r.
%
% r    - matrix containing the corner 
%        coordinates of a polygonal base stored 
%        in the rows of matrix r.
%
% v    - the volume of the pyramid
% vr   - the first moment of volume relative to
%        the origin
% vrr  - the second moment of volume relative
%        to the origin
% h    - the pyramid height
% area - the base area
% n    - the ourward directed unit normal to
%        the base
%
% User m functions called: crosmat, polyxy
%----------------------------------------------

ns=size(r,1); 
na=sum(crosmat(r,r([2:ns,1],:)))'/2;
area=norm(na); n=na/area; p=null(n'); 
i=p(:,1); j=p(:,2);
if det([p,n])<0, j=-j; end;
r1=r(1,:); rr=r-r1(ones(ns,1),:); 
x=rr*i; y=rr*j;
[areat,xc,yc,axx,axy,ayy]=polyxy(x,y);
rc=r1'+xc*i+yc*j; h=r1*n; 
v=h*area/3; vr=v*3/4*rc;
axx=axx-area*xc^2; ayy=ayy-area*yc^2; 
axy=axy-area*xc*yc;
vrr=h/5*(area*rc*rc'+axx*i*i'+ayy*j*j'+ ...
    axy*(i*j'+j*i'));