function [v,rg,Irr,X,Y,Z,aprop,xd,zd,kn]=...
                   volrev(xd,zd,kn,th,nth,noplot)
%
% [v,rg,Irr,X,Y,Z,aprop,xd,zd,kn]=...
%                  volrev(xd,zd,kn,th,nth,noplot)
%~~~~~~~~~~~~~~~~~~~~~~~~~

% This function computes geometrical properties
% for a volume of revolution resulting when a
% closed curve in the (x,z) plane is rotated,
% through given angular limits, about the z axis.
% The cross section of the volume is defined by
% a spline curve passed through data points 
% (xd,zd) in the same manner as was done in
% function areaprop for plane areas.

% xd,zd - data vectors defining the spline 
%         interpolated boundary, which is 
%         traversed in a counterclockwise
%         direction
% kn    - indices of any points where slope
%         discontinuity is allowed to turn
%         sharp corners
% p     - vector of volume properties containing
%         [v, xcg, ycg, zcg, vxx, vyy, vzz,...
%         vxy, vyz, vzx] where v is the volume,
%         (xcg,ycg,zcg) are coordinatesof the
%         centroid, and the remaining properties
%         are volume integrals of the following
%         integrand:
%         [x.^, y.^2, z.^2, xy, yz, zx]*dxdyxz
% X,Y,Z - data arrays containing points on the
%         surface of revolution. Plotting these
%         points shows the solid volume with 
%         the ends left open. Function fill3 
%         be used to plot the surface with ends
%         closed
% aprop - a vector containing properties of the
%         area in the (x,z) plane which was used
%         to generate the volume. aprop=[area,...
%         xcentroidal, ycentroidal, axx, axz, azz]. 

% User m functions called: rotasurf, gcquad,
%         curve2d, anglefun, splined
%----------------------------------------------
if nargin==0 
  t1=-pi:pi/6:0; t2=0:pi/6:pi;
  Zd=[0,exp(i*t1),1/2+i+exp(i*t2)/2,0,-1];
  xd=real(Zd)+4; zd=imag(Zd);
  kn=[1,2,8,9,15,16];
  th=[-pi/2,pi]; nth=31;
end

% Plot a surface of revolution based on the 
% input data points
if nargin==6
  [X,Y,Z]=rotasurf(xd,zd,th,nth,1);
else
  [X,Y,Z]=rotasurf(xd,zd,th,nth); pause
end

% Obtain base points and weight factors for the
% composite Gauss formula of order seven used in 
% the numerical integration
nd=length(xd); nseg=nd-1; 
[dum,bp,wf]=gcquad([],1,nd,7,nseg);

% Evaluate complex points and derivative values
% on the spline curve which is rotated to form
% the volume of revolution
[u,uplot,up]=curve2d(xd,zd,kn,bp);
% plot(real(uplot),imag(uplot)), axis equal,shg
u=u(:); up=up(:); n=length(bp);
x=real(u); dx=real(up); z=imag(u);
dz=imag(up); da=x.*dz-z.*dx;

% Evaluate line integrals for area properties
p=[ones(n,1), x, z, x.^2, x.*z, z.^2, x.^3,...
        (x.^2).*z, x.*(z.^2)].*repmat(da,1,9);
p=(wf(:)'*p)./[2 3 3 4 4 4 5 5 5];

% Scale area properties by multipliers involving
% the rotation angle for the volume
f=anglefun(th(2))-anglefun(th(1));
v=f(1)*p(2); rg=f([2 3 1]).*p([4 4 5])/v;
vrr=[f([4 5 2]); f([5 6 3]); f([2 3 1])].*...
    [p([7 7 8]); p([7 7 8]); p([8 8 9])];
Irr=eye(3)*sum(diag(vrr))-vrr;
aprop=[p(1),p(2:3)/p(1),p(4:6)];