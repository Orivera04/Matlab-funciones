function surfmany(varargin) 
%function surfmany(x1,y1,z1,x2,y2,z2,...
%                x3,y3,z3,..,xn,yn,zn), 1/4/01
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