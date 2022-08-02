function [tr,ta,tra,z]=eliphole ...
                       (rx,ry,p,ang,zeta)
%
% [tr,ta,tra,z]=eliphole(rx,ry,p,ang,zeta)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% This function determines curvilinear 
% coordinate stresses around an elliptic hole 
% in a plate uniformly stressed at infinity.
%
% rx,ry    - ellipse semidiameters on the x and 
%            y axes
% p        - values of uniaxial tension at 
%            infinity
% ang      - angle of inclination in degrees 
%            of the tensile stress at infinity
% zeta     - curvilinear coordinate values for 
%            which stresses are evaluated
%
% tr       - tensile stress normal to an 
%            elliptical coordinate line
% ta       - tensile stress in a direction 
%            tangential to the elliptical 
%            coordinate line
% tra      - shear stress complementary to the 
%            normal stresses
% z        - points in the z plane where 
%            stresses are computed
%
% User m functions called: none
%----------------------------------------------

if nargin==0
  rx=2; ry=1; p=1; ang=90; 
  zeta=linspace(1,2,11)'* ...
       exp(i*linspace(0,2*pi,121));
end

% The complex stress functions and mapping 
% function have the form
%   phi(zeta)=b*zeta+c/zeta
%   psi(zeta)=d*zeta+e/zeta+f*zeta/(zeta^2-m)
%   z=w(zeta)=r(zeta+m/zeta)
%   Phi(zeta)=phi'(zeta)/w'(zeta)
%   Psi(zeta)=psi'(zeta)/w'(zeta)
%   d(Phi)/dz=(w'(zeta)*phi''(zeta)-...
%              w''(zeta)*phi'(zeta))/w'(zeta)^3

r=(rx+ry)/2; m=(rx-ry)/(rx+ry); 
z=r*(zeta+m./zeta); zeta2=zeta.^2; 
zeta3=zeta.^3; wp=r*(1-m./zeta2);
wpp=2*r*m./zeta3; a=exp(2*i*pi/180*ang); 
b=p*r/4; c=b*(2*a-m); d=-p*r/2*conj(a); 
e=-p*r/2*a/m; f=p*r/2*(m+1/m)*(a-m); 
phip=b-c./zeta2; phipp=2*c./zeta3; 
h=wp.*zeta; h=h./conj(h); 
Phi=phip./wp; Phipz=(wp.*phipp-wpp.*phip)./wp.^3;
Psi=(d-e./zeta2-f*(zeta2+m)./(zeta2-m).^2)./wp;
A=2*real(Phi); B=(conj(z).*Phipz+Psi).*h;
C=A-B; tr=real(C); ta=2*A-tr; tra=imag(B);
if nargin==0
  surf(real(z),imag(z),ta);
  xlabel('x axis'); ylabel('y axis');
  zlabel('circumferential stress');
  title(['Circumferential Stress Around ', ...
         'an Elliptical Hole']);
  colormap('default'), gra;   
  grid on; figure(gcf);
  print -deps eliphole
end