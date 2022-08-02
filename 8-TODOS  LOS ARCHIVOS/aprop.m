function [p,zplot]=aprop(xd,yd,kn)
%
% [p,zplot]=aprop(xd,yd,kn)
% ~~~~~~~~~~~~~~~~~~~~~~~~~
% This function determines geometrical properties
% of a general plane area bounded by a spline 
% curve
% 
% xd,yd - data points for spline interpolation
%         with the boundary traversed in counter-
%         clockwise direction. The first and last 
%         points must match for boundary closure.
% kn    - vector of indices of points where the
%         slope is discontinuous to handle corners
%         like those needed for shapes such as a
%         rectangle.
% p     - the vector [a,xcg,ycg,axx,axy,ayy]
%         containing the area, centroid coordinates,
%         moment of inertia about the y-axis,
%         product of inertia, and moment of inertia
%         about the x-axis.
% zplot - complex vector of boundary points for 
%         plotting the spline interpolated geometry.
%         The points include the numerical quadrature
%         points interspersed with data values.
%
% User functions called: gcquad, curve2d
if nargin==0 
  td=linspace(0,2*pi,13); kn=[1,13];
  xd=cos(td)+1; yd=sin(td)+1;
end
nd=length(xd); nseg=nd-1;
[dum,bp,wf]=gcquad([],1,nd,6,nseg);
[z,zplot,zp]=curve2d(xd,yd,kn,bp);
w=[ones(size(z)), z, z.*conj(z), z.^2].*...
   repmat(imag(conj(z).*zp),1,4);
v=(wf'*w)./[2,3,8,8]; vr=real(v); vi=imag(v);
p=[vr(1:2),vi(2),vr(3)+vr(4),vi(4),vr(3)-vr(4)];
p(2)=p(2)/p(1); p(3)=p(3)/p(1);