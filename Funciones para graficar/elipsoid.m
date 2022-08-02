function [x,y,z]=elipsoid(a,b,c,n,noplot)
%
% [x,y,z]=elipsoid(a,b,c,n,noplot)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% This function plots an ellipsoid having semi-
% diameters a,b,c
% a,b,c  - semidiameters of the ellipsoid defined
%          by (x/a)^2+(y/b)^2+(z/c)^2=1
% n      - vector [nth,nph] giving the number of
%          theta values and phi values used to plot
%          the surface
% noplot - omit this parameter if no plot is desired
% x,y,z  - matrices of points on the surface
%
% User m functions called: none
%----------------------------------------------

if nargin==0, a=2; b=1.5; c=1; n=[17,33]; end
nth=n(1); nph=n(2); 
th=linspace(-pi/2,pi/2,nth)'; ph=linspace(-pi,pi,nph);
x=a*cos(th)*cos(ph); y=b*cos(th)*sin(ph);
z=c*sin(th)*ones(size(ph));
if nargin<5
   surf(x,y,z); axis equal
   title('ELLIPSOID'), xlabel('x axis')
   ylabel('y axis'), zlabel('z axis')
   colormap([1 1 1]); grid on, figure(gcf)
end