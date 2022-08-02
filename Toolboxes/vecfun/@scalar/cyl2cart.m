function B=cyl2cart(A)
%CYL2CART  Transform cylindrical to Cartesian coordinates.
%   T = CYL2CART(S) transforms the scalar function S
%   in cylindrical coordinates to Cartesian coordinates,
%   where T is a scalar function.
%
%   See also CART2CYL, CART2SPH, CYL2SPH, SPH2CART, SPH2CYL.

% Copyright (c) 2001-04-17, B. Rasmus Anthin.

B=A;
if ~strcmp(type(A),'cyl'), return,end
if strcmp(type(A),'cart'), return,end
if ~isempty([A.xval A.yval A.zval]), error('No variables can be constant when transforming coordinates.'),end
[x y z]=vars(A);
X=linspace(A.x(1),A.x(2),A.x(3));
Y=linspace(A.y(1),A.y(2),A.y(3));
Z=linspace(A.z(1),A.z(2),A.z(3));
[X Y Z]=meshgrid(X,Y,Z);
[X Y Z]=pol2cart(Y,X,Z);
xmin=min(min(min(X)));xmax=max(max(max(X)));
B.x=[xmin xmax A.x(3)];
ymin=min(min(min(Y)));ymax=max(max(max(Y)));
B.y=[ymin ymax A.y(3)];
zmin=min(min(min(Z)));zmax=max(max(max(Z)));
B.z=[zmin zmax A.z(3)];
%[B.x(1:2) B.y(1:2) B.z(1:2)]=pol2cart(A.y(1:2),A.x(1:2),A.z(1:2));
%B.xval=[];B.yval=[];B.zval=[];
B.f=strrepx(B.f,x,'sqrt(x^2+y^2)','');
B.f=strrepx(B.f,y,'atan(y/x)','');
B.F=strrepx(B.F,x,'sqrt(x.^2+y.^2)','');
B.F=strrepx(B.F,y,'atan2(y,x)','');
B.coords='cart';