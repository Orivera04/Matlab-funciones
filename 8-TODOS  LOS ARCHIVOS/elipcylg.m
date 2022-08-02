function [x,y,F]=elipcyl(a,n,rx,ry,ang)
% 
% [x,y,F]=elipcyl(a,n,rx,ry,ang)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% This function computes the flow field around 
% an elliptic cylinder. The velocity direction 
% at infinity is arbitrary.
%
% a     - defines the region -a<x<a, -a<y<a 
%         within which the flow field is 
%         computed
% n     - this determines the grid size which 
%         uses n by n points
% rx,ry - major and minor semi-diameters af the 
%         ellipse lying on the x and y axes, 
%         respectively
% ang -   the angle in degrees which the 
%         velocity at infinity makes with the 
%         x axis
%
% x,y   - matrices of points where the velocity 
%         potential is computed
% F     - matrix of complex velocity potential 
%         values. This function is set to zero 
%         inside the ellipse, where the 
%         potential is actually not defined
%
% User m functions called:  none

% default data for a 2 by 1 ellipse
if nargin==0 
 a=5; n=81; rx=2; ry=1; ang=30;
end 

% Compute a square grid in the z plane.
ar=pi/180*ang; p=(rx+ry)/2*exp(-i*ar); 
cp=conj(p); d=linspace(-a,a,n); 
[x,y]=meshgrid(d,d); m=sqrt(rx^2-ry^2);

% Obtain points in the zeta plane outside 
% the ellipse 
z=x(:)+i*y(:); k=find((x/rx).^2+(y/ry).^2>=1); 
Z=z(k); zeta=(Z+sqrt(Z-m).*sqrt(Z+m))/(rx+ry); 
F=zeros(n*n,1);

% Evaluate the potential for a circular 
% cylinder
F(k)=p*zeta+cp./zeta; F=reshape(F,n,n);

% Contour the stream function to show the 
% direction of flow

clf; contourf(x(1,:),y(:,1),abs(imag(F)),30);
axis('square'); zb=exp(i*linspace(0,2*pi,101)); 
xb=rx*real(zb); yb=ry*imag(zb);
xb(end)=xb(1); yb(end)=yb(1);
hold on; fill(xb,yb,[.5 .5 .5]); 
xlabel('x axis'); ylabel('y axis');
title(['Elliptic Cylinder Flow Field for ', ...
       'Angle = ',num2str(ang),' Degrees']); 
colormap([1 1 1]); figure(gcf); hold off;
%print -deps elipcyl