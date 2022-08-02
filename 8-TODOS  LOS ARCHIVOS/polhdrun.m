function polhdrun      
% Example: polhdrun
% ~~~~~~~~~~~~~~~~~
%
% This program illustrates the use of routine
% polhedrn to calculate the geometrical 
% properties of a polyhedron.
%
% User m functions called: 
%      crosmat, polyxy, cubrange, pyramid,
%      polhdplt, polhedrn

x=[2 2 2 2 2 2 0 0 0 0 0 0]-1;
y=[0 4 4 2 3 3 0 4 4 2 3 3];
z=[0 0 4 1 1 2 0 0 4 1 1 2];
idface=[1  2  3  6  5  4  6  3; ...
        1  3  9  7  0  0  0  0; ...
        1  7  8  2  0  0  0  0; ...
        2  8  9  3  0  0  0  0; ...
        7  9 12 10 11 12  9  8; ...
        4 10 12  6  0  0  0  0; ...
        4  5 11 10  0  0  0  0; ...
        5  6 12 11  0  0  0  0];
polhdplt(x,y,z,idface,[1,1,1]); 
[v,rc,vrr,irr]=polhedrn(x,y,z,idface)

%=============================================

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

%=============================================

function [area,xbar,ybar,axx,axy,ayy]=polyxy(x,y)
%
% [area,xbar,ybar,axx,axy,ayy]=polyxy(x,y)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% This function computes the area, centroidal 
% coordinates, and inertial moments of an 
% arbitrary polygon.
% 
% x,y       - vectors containing the corner 
%             coordinates. The boundary is 
%             traversed in a counterclockwise 
%             direction
%
% area      - the polygon area
% xbar,ybar - the centroidal coordinates
% axx       - integral of x^2*dxdy
% axy       - integral of xy*dxdy
% ayy       - integral of y^2*dxdy 
%
% User m functions called: none
%----------------------------------------------

n=1:length(x); n1=n+1; 
x=[x(:);x(1)]; y=[y(:);y(1)];
a=(x(n).*y(n1)-y(n).*x(n1))'; 
area=sum(a)/2; a6=6*area;
xbar=a*(x(n)+x(n1))/a6; ybar=a*(y(n)+y(n1))/a6;
ayy=a*(y(n).^2+y(n).*y(n1)+y(n1).^2)/12;
axy=a*(x(n).*(2*y(n)+y(n1))+x(n1).* ...
    (2*y(n1)+y(n)))/24;
axx=a*(x(n).^2+x(n).*x(n1)+x(n1).^2)/12;

%=============================================

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
% n    - the outward directed unit normal to
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

%=============================================

function polhdplt(x,y,z,idface,colr)
%
% polhdplt(x,y,z,idface,colr)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% This function makes a surface plot of an 
% arbitrary polyhedron.
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
% colr   - character string or a vector 
%          defining the surface color
%
% User m functions called: cubrange
%----------------------------------------------

if nargin<5, colr=[1 0 1]; end
hold off, close; nf=size(idface,1);
v=cubrange([x(:),y(:),z(:)],1.1); 
for k=1:nf
  i=idface(k,:); i=i(find(i>0));
  xi=x(i); yi=y(i); zi=z(i);
  fill3(xi,yi,zi,colr); hold on;
end
axis(v); grid on;
xlabel('x axis'); ylabel('y axis');
zlabel('z axis');
title('Surface Plot of a General Polyhedron');
figure(gcf); hold off;

%=============================================

function c=crosmat(a,b)
%
% c=crosmat(a,b)
% ~~~~~~~~~~~~~~
%
% This function computes the vector cross
% product for vectors stored in the rows
% of matrices a and b, and returns the 
% results in the rows of c.
%
% User m functions called: none
%----------------------------------------------

c=[a(:,2).*b(:,3)-a(:,3).*b(:,2),...
   a(:,3).*b(:,1)-a(:,1).*b(:,3),...
   a(:,1).*b(:,2)-a(:,2).*b(:,1)];

%=============================================

% function range=cubrange(xyz,ovrsiz)
% See Appendix B
