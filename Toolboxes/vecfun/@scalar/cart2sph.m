function B=cart2sph(A)
%CART2SPH  Transform Cartesian to spherical coordinates.
%   T = CART2SPH(S) transforms the scalar function S
%   in Cartesian coordinates to spherical coordinates,
%   where T is a scalar function.
%
%   See also CART2CYL, CYL2CART, CYL2SPH, SPH2CART, SPH2CYL.

% Copyright (c) 2001-04-17, B. Rasmus Anthin.

B=A;
if ~strcmp(type(A),'cart'), return,end
if strcmp(type(A),'sph'), return,end
if ~isempty([A.xval A.yval A.zval]), error('No variables can be constant when transforming coordinates.'),end
[x y z]=vars(A);
X=linspace(A.x(1),A.x(2),A.x(3));
Y=linspace(A.y(1),A.y(2),A.y(3));
Z=linspace(A.z(1),A.z(2),A.z(3));
[X Y Z]=meshgrid(X,Y,Z);
warns=warning;warning off
XX=sqrt(X.^2+Y.^2+Z.^2); YY=acos(Z./XX); ZZ=atan2(Y,X);
warning(warns)
xmin=min(min(min(XX)));xmax=max(max(max(XX)));
B.x=[xmin xmax A.x(3)];
ymin=min(min(min(YY)));ymax=max(max(max(YY)));
B.y=[ymin ymax A.y(3)];
zmin=min(min(min(ZZ)));zmax=max(max(max(ZZ)));
B.z=[zmin zmax A.z(3)];
%[B.z(1:2) B.y(1:2) B.x(1:2)]=cart2sph(A.x(1:2),A.y(1:2),A.z(1:2));
%B.xval=[];B.yval=[];B.zval=[];
B.f=strrepx(B.f,x,'(R*sin(theta)*cos(phi))','');
B.f=strrepx(B.f,y,'(R*sin(theta)*sin(phi))','');
B.f=strrepx(B.f,z,'(R*cos(theta))','');
B.F=strrepx(B.F,x,'(R.*sin(theta).*cos(phi))','');
B.F=strrepx(B.F,y,'(R.*sin(theta).*cos(phi))','');
B.F=strrepx(B.F,z,'(R.*cos(theta))','');
B.coords='sph';