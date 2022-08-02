function B=sph2cart(A)
%SPH2CART  Transform spherical to Cartesian coordinates.
%   T = SPH2CART(S) transforms the scalar function S
%   in spherical coordinates to Cartesian coordinates,
%   where T is a scalar function.
%
%   See also CART2SPH, CART2CYL, CYL2CART, CYL2SPH, SPH2CYL.

% Copyright (c) 2001-04-17, B. Rasmus Anthin.

B=A;
if ~strcmp(type(A),'sph'), return,end
if strcmp(type(A),'cart'), return,end
if ~isempty([A.xval A.yval A.zval]), error('No variables can be constant when transforming coordinates.'),end
[x y z]=vars(A);
X=linspace(A.x(1),A.x(2),A.x(3));
Y=linspace(A.y(1),A.y(2),A.y(3));
Z=linspace(A.z(1),A.z(2),A.z(3));
[X Y Z]=meshgrid(X,Y,Z);
XX=X.*sin(Y).*cos(Z); YY=X.*sin(Y).*sin(Z); ZZ=X.*cos(Y);
xmin=min(min(min(XX)));xmax=max(max(max(XX)));
B.x=[xmin xmax A.x(3)];
ymin=min(min(min(YY)));ymax=max(max(max(YY)));
B.y=[ymin ymax A.y(3)];
zmin=min(min(min(ZZ)));zmax=max(max(max(ZZ)));
B.z=[zmin zmax A.z(3)];
%[B.x(1:2) B.y(1:2) B.z(1:2)]=sph2cart(A.z(1:2),A.y(1:2),A.x(1:2));
%B.xval=[];B.yval=[];B.zval=[];
B.f=strrepx(B.f,x,'sqrt(x^2+y^2+z^2)','');
B.f=strrepx(B.f,y,'acos(z/sqrt(x^2+y^2+z^2))','');
B.f=strrepx(B.f,z,'atan(y/x)','');
B.F=strrepx(B.F,x,'sqrt(x.^2+y.^2+z.^2)','');
B.F=strrepx(B.F,y,'acos(z./sqrt(x.^2+y.^2+z.^2))','');
B.F=strrepx(B.F,z,'atan2(y,x)','');
B.coords='cart';