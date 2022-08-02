function [v,rc,vrr]=srfv(x,y,z)
%
% [v,rc,vrr]=srfv(x,y,z)
% ~~~~~~~~~~~~~~~~~~~~~~
%
% This function computes the volume, centroidal
% coordinates, and inertial tensor for a volume
% covered by surface coordinates contained in
% arrays x,y,z
%
% x,y,z   - matrices containing the coordinates
%           of a grid of points covering the
%           surface of the solid
% v       - volume of the solid
% rc      - centroidal coordinate vector of the
%           solid
% vrr     - inertial tensor for the solid with the
%           mass density taken as unity
%
% User functions called: scatripl proptet
%-----------------------------------------------

% p=inline(...
%  'v*(eye(3)*(r(:)''*r(:))-r(:)*r(:)'')','v','r');

%d=mean([x(:),y(:),z(:)]); 
%x=x-d(1); y=y-d(2); z=z-d(3);

[n,m]=size(x); i=1:n-1; I=i+1; j=1:m-1; J=j+1;
xij=x(i,j); yij=y(i,j); zij=z(i,j);
xIj=x(I,j); yIj=y(I,j); zIj=z(I,j);
xIJ=x(I,J); yIJ=y(I,J); zIJ=z(I,J);
xiJ=x(i,J); yiJ=y(i,J); ziJ=z(i,J);

% Tetrahedron volumes
v1=scatripl(xij,yij,zij,xIj,yIj,zIj,xIJ,yIJ,zIJ);
v2=scatripl(xij,yij,zij,xIJ,yIJ,zIJ,xiJ,yiJ,ziJ);
v=sum(sum(v1+v2));

% First moments of volume
X1=xij+xIj+xIJ; X2=xij+xIJ+xiJ;
Y1=yij+yIj+yIJ; Y2=yij+yIJ+yiJ;
Z1=zij+zIj+zIJ; Z2=zij+zIJ+ziJ;
vx=sum(sum(v1.*X1+v2.*X2));
vy=sum(sum(v1.*Y1+v2.*Y2));
vz=sum(sum(v1.*Z1+v2.*Z2));

% Second moments of volume
vrr=proptet(v1,xij,yij,zij,xIj,yIj,zIj,...
    xIJ,yIJ,zIJ,X1,Y1,Z1)+...
    proptet(v2,xij,yij,zij,xIJ,yIJ,zIJ,...
    xiJ,yiJ,ziJ,X2,Y2,Z2);
rc=[vx,vy,vz]/v/4; vs=sign(v);
v=abs(v)/6; vrr=vs*vrr/120;
vrr=[vrr([1 4 5]), vrr([4 2 6]), vrr([5 6 3])]';
vrr=eye(3,3)*sum(diag(vrr))-vrr;

%vrr=vrr-p(v,rc)+p(v,rc+d); rc=rc+d;