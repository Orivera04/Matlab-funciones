function [x1,y1,x2,y2,x3,y3,xf,yf,zf]= ...
                             srfex(da,na,df,nf)
% [x1,y1,x2,y2,x3,y3,xf,yf,zf]= ...
%                            srfex(da,na,df,nf)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% This graphics example draws three toruses 
% intersecting a spike.
%
% User m functions called: frus, surfmany

if nargin==0
  da=[4.0,.45]; na=[42,15];  
  df=[2.2,0,15]; nf=[43,4];
end

% Create a torus with polygonal cross section.
% Data for the torus is stored in da and na

r0=da(1); r1=da(2); nfaces=na(1); nlat=na(2);
t=linspace(0,2*pi,nlat)';
xz=[r0+r1*cos(t),r1*sin(t)]; 
z1=xz(:,2); z1=z1(:,ones(1,nfaces+1));
th=linspace(0,2*pi,nfaces+1);
x1=xz(:,1)*cos(th); y1=xz(:,1)*sin(th); 
y2=x1; z2=y1; x2=z1; y3=x2; z3=y2; x3=z2;

% Create a frustum of a pyramid. Data for the
% frustum is stored in df and nf
rb=df(1); rt=df(2); h=df(3); 
[xf,yf,zf]=frus(rb,rt,h,nf); zf=zf-.35*h;

% Plot four figures combined together
hold off; clf; close;
surfmany(x1,y1,z1,x2,y2,z2,x3,y3,z3,xf,yf,zf)
xlabel('x axis'); ylabel('y axis'); 
zlabel('z axis');
title('Spike and Intersecting Toruses');
axis equal; axis('off'); 
colormap([1 1 1]); figure(gcf); hold off;
% print -deps srfex

%=============================================

function [X,Y,Z]=frus(rb,rt,h,n,noplot)
%
% [X,Y,Z]=frus(rb,rt,h,n,noplot)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% This function computes points on the surface 
% of a conical frustum which has its axis along 
% the z axis.
%
% rb,rt,h - the base radius,top radius and 
%           height
% n       - vector of two integers defining the 
%           axial and circumferential grid 
%           increments on the surface
% noplot  - parameter input when no plot is
%           desired
%
% X,Y,Z   - points on the surface
%
% User m functions called: none

if nargin==0
  rb=2; rt=1; h=3; n=[23, 35]; 
end

th=linspace(0,2*pi,n(2)+1)'-pi/n(2); 
sl=sqrt(h^2+(rb-rt)^2); s=sl+rb+rt;
m=ceil(n(1)/s*[rb,sl,rt]); 
rbot=linspace(0,rb,m(1));
rside=linspace(rb,rt,m(2));
rtop=linspace(rt,0,m(3));
r=[rbot,rside(2:end),rtop(2:end)]; 
hbot=zeros(1,m(1));
hside=linspace(0,h,m(2));
htop=h*ones(1,m(3));
H=[hbot,hside(2:end),htop(2:end)];
Z=repmat(H,n(2)+1,1); 
xy=exp(i*th)*r; X=real(xy); Y=imag(xy);
if nargin<5
  surf(X,Y,Z); title('Frustum'); xlabel('x axis')
  ylabel('y axis'), zlabel('z axis')
  grid on, colormap([1 1 1]);
  figure(gcf); 
end

%=============================================

function surfmany(varargin) 
%function surfmany(x1,y1,z1,x2,y2,z2,...
%                x3,y3,z3,..,xn,yn,zn)
% This function plots any number of surfaces 
% on the same set of axes without shape 
% distortion. When no input is given then a
% six-legged solid composed of spheres and
% cylinders is shown. 
%
% User m functions called: none
%----------------------------------------------

if nargin==0  
  % Default data for a six-legged solid
  n=10; rs=.25; d=7; rs=2; rc=.75; 
  [xs,ys,zs]=sphere;  [xc,yc,zc]=cylinder;
  xs=rs*xs; ys=rs*ys; zs=rs*zs; 
  xc=rc*xc; yc=rc*yc; zc=2*d*zc-d;
  x1=xs; y1=ys; z1=zs; 
  x2=zs+d; y2=ys; z2=xs;
  x3=zs-d; y3=ys; z3=xs; 
  x4=xs; y4=zs-d; z4=ys;
  x5=xs; y5=zs+d; z5=ys;
  x6=xs; y6=ys; z6=zs+d; 
  x7=xs; y7=ys; z7=zs-d;
  x8=xc; y8=yc; z8=zc;
  x9=zc; y9=xc; z9=yc; 
  x10=yc; y10=zc; z10=xc; 
	varargin={x1,y1,z1,x2,y2,z2,x3,y3,z3,...
		x4,y4,z4,x5,y5,z5,x6,y6,z6,x7,y7,z7,...
		x8,y8,z8,x9,y9,z9,x10,y10,z10};
end 

% Find the data range
n=length(varargin); 
r=realmax*[1,-1,1,-1,1,-1];
s=inline('min([a;b])','a','b');
b=inline('max([a;b])','a','b');
for k=1:3:n	
	x=varargin{k}; y=varargin{k+1}; 
	z=varargin{k+2};
	x=x(:); y=y(:); z=z(:);
	r(1)=s(r(1),x); r(2)=b(r(2),x);
	r(3)=s(r(3),y); r(4)=b(r(4),y);
	r(5)=s(r(5),z); r(6)=b(r(6),z);
end

% Plot each surface
hold off, newplot
for k=1:3:n
	x=varargin{k}; y=varargin{k+1}; 
	z=varargin{k+2};
	surf(x,y,z); axis(r), hold on	
end

% Set axes and display the combined plot 
axis equal, axis(r), grid on
xlabel('x axis'), ylabel('y axis')
zlabel('z axis')
title('SEVERAL SURFACES COMBINED')
% colormap([127/255 1 212/255]); % aquamarine
colormap([1 1 1]);, figure(gcf), hold off 