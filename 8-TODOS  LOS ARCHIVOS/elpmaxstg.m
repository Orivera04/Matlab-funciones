function elpmaxst      
% Example: elpmaxst
% ~~~~~~~~~~~~~~~~~
%
% MATLAB example to plot the stress 
% concentration around an elliptic hole
% as a function of the semi-diameter ratio.
%
% User m functions required: eliphole

rx=2; ry=1; p=1; ang=90; ifplot=1;
zeta=linspace(1,2,11)'* ...
       exp(i*linspace(0,2*pi,121));
eliphole(rx,ry,p,ang,zeta,1);

r=linspace(1.001,10,19); tamax=zeros(size(r));
for j=1:19 
  [tr,tamax(j)]=eliphole(r(j),1,1,90,1);
end
plot(r,tamax,'-k',r,tamax,'ok');
title(['Stress Concentration Around an ', ...
       'Elliptical Hole']);
xlabel(['ratio ( max diameter ) / ', ...
        '( min diameter )']);
ylabel(['( max circumferential stress ) / ',...
        '( plate tension at infinity )']);
grid on; figure(gcf);
print -deps elpmaxst

%=============================================

function [tr,ta,tra,z]=eliphole...
                 (rx,ry,p,ang,zeta,ifplot)
%
% [tr,ta,tra,z]=eliphole(rx,ry,p,ang,...
%                              zeta,ifplot)
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
% ifplot   - optional parameter that is given
%            a value if a surface plot of the
%            circumferential stress is desired
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

if nargin<6, ifplot=0; end
if nargin==0
  rx=2; ry=1; p=1; ang=90; ifplot=1;
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
if ifplot>0
  %colormap('gray'); brighten(.95);
  close; surf(real(z),imag(z),ta);
  xlabel('x axis'); ylabel('y axis');
  zlabel('circumferential stress');
  title(['Circumferential Stress Around ', ...
         'an Elliptical Hole']);
  grid on; gra(.9),figure(gcf); pause 
  print -deps eliphole
end
