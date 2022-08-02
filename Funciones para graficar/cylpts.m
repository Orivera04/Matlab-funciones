function [x,y,z]=cylpts(...
                 axial,circum,rad,len,r0,vectax)
% [x,y,z]=cylpts(axial,circum,rad,len,r0,vectax)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% This function computes a grid of points on the 
% surface of a circular cylinder
%
% User m functions called: ortbasis

U=2*rad+len; u=U*axial(:); n=length(u);
v=2*pi*circum(:)'; m=length(v);
ud=[0,rad,rad+len,U];
r=interp1(ud,[0,rad,rad,0],u);
z=interp1(ud,[0,0,len,len],u);
x=r*cos(v); y=r*sin(v); z=repmat(z,1,m); 
% w=basis(vectax)*[x(:),y(:),z(:)]';
w=ortbasis(vectax)*[x(:),y(:),z(:)]';

x=r0(1)+reshape(w(1,:),n,m); 
y=r0(2)+reshape(w(2,:),n,m);
z=r0(3)+reshape(w(3,:),n,m);