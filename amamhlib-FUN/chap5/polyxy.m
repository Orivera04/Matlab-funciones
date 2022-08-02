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