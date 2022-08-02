function B=cart2cyl(A)
%CART2CYL  Transform Cartesian to cylindrical coordinates.
%   T = CART2CYL(S) transforms the scalar function S
%   in Cartesian coordinates to cylindrical coordinates,
%   where T is a scalar function.
%
%   See also CART2SPH, CYL2CART, CYL2SPH, SPH2CART, SPH2CYL.

% Copyright (c) 2001-04-17, B. Rasmus Anthin.

B=A;
if ~strcmp(type(A),'cart'), return,end
if strcmp(type(A),'cyl'), return,end
if ~isempty([A.xval A.yval A.zval]), error('No variables can be constant when transforming coordinates.'),end
[x y z]=vars(A);
X=linspace(A.x(1),A.x(2),A.x(3));
Y=linspace(A.y(1),A.y(2),A.y(3));
Z=linspace(A.z(1),A.z(2),A.z(3));
[X Y Z]=meshgrid(X,Y,Z);
[Y X Z]=cart2pol(X,Y,Z);
xmin=min(min(min(X)));xmax=max(max(max(X)));
B.x=[xmin xmax A.x(3)];
ymin=min(min(min(Y)));ymax=max(max(max(Y)));
B.y=[0 2*pi A.y(3)];
zmin=min(min(min(Z)));zmax=max(max(max(Z)));
B.z=[zmin zmax A.z(3)];
%[B.y(1:2) B.x(1:2) B.z(1:2)]=cart2pol(A.x(1:2),A.y(1:2),A.z(1:2));
%B.xval=[];B.yval=[];B.zval=[];
B.f=strrepx(B.f,x,'(r*cos(phi))','');
B.f=strrepx(B.f,y,'(r*sin(phi))','');
B.F=strrepx(B.F,x,'(r.*cos(phi))','');
B.F=strrepx(B.F,y,'(r.*cos(phi))','');
B.coords='cyl';