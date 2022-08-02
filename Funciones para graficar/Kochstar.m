%Eigenvalues of 'von Koch star' Fractal using FEMLAB3.0 command lines
%n= number of refinement of the kockstar
%by Per Sundqvist june 2004
cd Fractals
clear;clc;clf;

n=4;
clear XY XY2 XY3 x1 x2 x3 y1 y2 y3 x y;
[x,y]=koch_xy(n);
Nx=length(x);
x1=x;y1=-y;
w=60*2*pi/360;
XY(1,:)=x;XY(2,:)=y;
XY2=flipdim([cos(w) -sin(w);sin(w) cos(w)]*XY,2);
x2=XY2(1,:);y2=XY2(2,:);
XY3=flipdim([cos(-w) -sin(-w);sin(-w) cos(-w)]*XY,2);
x3=XY3(1,:)+1/2;y3=XY3(2,:)+sqrt(3)/2;
xx=x1(1:Nx-1);
xx(Nx:2*Nx-2)=x3(1:Nx-1);
xx(2*Nx-1:3*Nx-3)=x2(1:Nx-1);
yy=y1(1:Nx-1);
yy(Nx:2*Nx-2)=y3(1:Nx-1);
yy(2*Nx-1:3*Nx-3)=y2(1:Nx-1);
clf;plot(xx,yy);axis equal;axis off;
clear XY XY2 XY3 x1 x2 x3 y1 y2 y3 x y;

st=poly2(xx,yy);
fem.geom=st;
figure(1);geomplot(fem,'PointLabels','off','EdgeLabels','off','edgearrow','off',...
    'Pointmarker','.','Pointcolor','r','Labelcolor','r');axis equal

%--- Eigen energies, lambda ---
N_btot=flgeomnes(fem.geom);     %Total number of edges
count=1;
for j=1:N_btot
    vect(count)=j;
    vect(count+1)=4;
    count=count+2;
end

fem.mesh=meshinit(fem,'hmax',0.02,'Hnum',{[],vect});meshplot(fem);axis equal;
fem.equ.c=1;
fem.equ.a=0;
fem.equ.da=1;
fem.bnd.h=1;
fem.xmesh=meshextend(fem);
fem.sol=femeig(fem,'eigfun','fleig','eigpar',20);
lambda=fem.sol.lambda
for i=1:length(lambda)
figure(2), postplot(fem,...
	'tridata','u',...
	'solnum', i,...
	'axisvisible','off');axis equal
text(-0.2,-0.2,['\lambda_{',int2str(i),'} = ',int2str(lambda(i))])
pause(1.5)
end

figure(2), postplot(fem,...
	'tridata','u',...
	'solnum', 13,...
	'axisvisible','off');axis equal
