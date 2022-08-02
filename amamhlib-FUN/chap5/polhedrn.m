function [v,rc,vrr,irr]=polhedrn(x,y,z,idface)
%
% [v,rc,vrr,irr]=polhedrn(x,y,z,idface)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% This function determines the volume, 
% centroidal coordinates and inertial moments 
% for an arbitrary polyhedron.
%
% x,y,z  - vectors containing the corner 
%          indices of the polyhedron
% idface - a matrix in which row j defines the 
%          corner indices of the j'th face. 
%          Each face is traversed in a 
%          counterclockwise sense relative to 
%          the outward normal. The column 
%          dimension equals the largest number 
%          of indices needed to define a face. 
%          Rows requiring fewer than the 
%          maximum number of corner indices are 
%          padded with zeros on the right.
%
% v      - the volume of the polyhedron
% rc     - the centroidal radius
% vrr    - the integral of R*R'*d(vol)
% irr    - the inertia tensor for a rigid body
%          of unit mass obtained from vrr as 
%          eye(3,3)*sum(diag(vrr))-vrr
%
% User m functions called: pyramid
%----------------------------------------------

r=[x(:),y(:),z(:)]; nf=size(idface,1); 
v=0; vr=0; vrr=0;
for k=1:nf
  i=idface(k,:); i=i(find(i>0));
  [u,ur,urr]=pyramid(r(i,:)); 
  v=v+u; vr=vr+ur; vrr=vrr+urr;
end
rc=vr/v; irr=eye(3,3)*sum(diag(vrr))-vrr;