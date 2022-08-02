function [z,a,b]=elipdisk(zeta,rx,ry)
%
% [z,a,b]=elipdisk(zeta,rx,ry)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% This function computes a rational function 
% mapping abs(zeta)<=1 onto an elliptical disk 
% defined by (x/rx)^2+(y/ry)^2<=1. Boundary 
% points are computed using theory from 
%   P. Henrici, Applied Complex Analysis, 
%   Vol 3, p391.
% The rational function approximation has the 
% form:
%        z=sum(a(j)*zeta^(2*j-1)) /
%          (1+sum(b(j)*zeta^(2*j));
%
%  zeta  - matrix of points with abs(zeta)<=1
%  rx,ry - ellipse semidiameters on x and y 
%          axes
%
%  z     - points into which zeta maps
%  a,b   - coefficients in the rational 
%          function defining the map
%
% User m functions called: ratcof
%----------------------------------------------

ntrms=100; ntheta=251; 
tau=(0:2*pi/ntheta:2*pi)'; 
ep=(rx-ry)/(rx+ry); 
z=exp(i*tau); z=z+ep*conj(z);
j=1:ntrms;  ep=ep.^j; ep=ep./(j.*(1+ep.*ep));
theta=tau+2*( sin((2*tau+pi)*j)*ep'); 
zta=exp(i*theta); z=rx/max(real(z))*z; 
[a,b]=ratcof(zta.^2,z./zta,8);
a=fix(real(1e8*a))/1e8; b=fix(real(1e8*b))/1e8;
af=flipud(a(:)); bf=flipud([1;b(:)]); 
zta2=zeta.^2;
z=zeta.*polyval(af,zta2)./polyval(bf,zta2);