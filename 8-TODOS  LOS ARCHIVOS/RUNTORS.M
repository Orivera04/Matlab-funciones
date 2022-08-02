function runtors(ntrms)      
% Example: runtors(ntrms)
% ~~~~~~~~~~~~~~~~
%
% Example showing torsional stress computation
% for a beam of square cross section using
% conformal mapping and a complex stress 
% function.
%
% ntrms - number of series terms used to
%         represent abs(w(zeta))^2
%
% User m functions called: torstres, mapsqr

% Generate zeta values defining half of a side
theta=linspace(0,pi/4,501); zeta=exp(i*theta);
if nargin==0, ntrms=800; end

% Compute stresses using an approximate rational
% function mapping function for the square
[tr,ta,z,c,C]= ...
  torstres('mapsqr',zeta,ntrms,4*1024);

% Results from the exact solution
n=1:2:13; 
tmexact=1-8/pi^2*sum(1./(n.^2.*cosh(n*pi/2)));
err=abs(ta(1)/2-tmexact)*100/tmexact;
stfexct=16/3-1024/pi^5*sum(tanh(pi/2*n)./n.^5);
stfaprx=8/3-pi*sum((1:ntrms)'.* ...
        abs(C(2:ntrms+1)).^2);
ster=100*abs(stfaprx-stfexct)/stfexct;

% Plot circumferential and normal stresses at 
% the boundary
th=180/pi*theta; 
close; plot(imag(z),tr/2,'k:',imag(z),ta/2,'k-')
xlabel('y distance along the side');
ylabel('shear stresses at the boundary'); 
title(['Torsional Shear Stresses on a ', ...
       'Square Cross Section']);
text(.05,.40, ...
  ['Max Shear Stress = ',num2str(max(ta)/2)]);
text(.05,.34, ...
  ['Number of Series Terms = ',num2str(ntrms)]);
text(.05,.28, ...
  ['Maximum Stress Error = ',num2str(err),'%']);
text(.05,.22,['Stiffness Factor Error = ', ...
  num2str(ster),'%']);
legend('Radial shear stress',...
  'Tangential shear stress');
figure(gcf);
%disp('Use mouse to locate legend block');
%disp('Press [Enter] when finished'); 
%print -deps torsion

%=============================================

function [trho,talpha,z,c,C]= ...
                torstres(mapfun,zeta,ntrms,nft)
%
% [trho,talpha,z,c,C]= ...
%               torstres(mapfun,zeta,ntrms,nft)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% This function computes torsional stresses in 
% a beam such that abs(zeta)<=1 is mapped onto 
% the beam cross section by a function named 
% mapfun.
%
% mapfun - a character string giving the name 
%          of the mapping function
% zeta   - values in the zeta plane 
%          corresponding to which torsional 
%          stresses are computed
% ntrms  - the number of terms used in the 
%          series expansion of the mapping 
%          function
% nft    - the number of function values 
%          employed to compute Fourier 
%          coefficients of the complex stress 
%          function
%
% trho   - torsional stresses in directions 
%          normal to the lines into which 
%          abs(zeta)=const map. These values 
%          should be zero at the boundary 
%          corresponding to abs(zeta)=1.
% talpha - torsional stresses in directions 
%          tangent to the curves into which 
%          abs(zeta)=const map. The maximum 
%          value of shear stress always occurs 
%          at some point on the boundary defined 
%          by abs(zeta)=1.
% z      - values of z where stresses are 
%          computed
% c      - coefficients in the series expansion 
%          of the complex stress function
% C      - complex Fourier coefficients of 
%          z.*conj(z) on the boundary of the 
%          beam cross section
%
% User m functions called:  none
%----------------------------------------------
      
if nargin<4, nft=4096; end; 
if nargin<3, ntrms=800; end

% Compute boundary values of the mapping 
% function needed to construct the complex 
% stress function
zetab=exp(i*linspace(0,2*pi*(nft-1)/nft,nft));
zb=feval(mapfun,zetab); zb=zb(:);

% Evaluate z and z'(zeta) at other 
% desired points
[z,zp]=feval(mapfun,zeta);

% Compute Fourier coefficients for the complex 
% stress function and its derivative
C=fft(zb.*conj(zb))/nft; 
c=i*C(2:ntrms+1).*(1:ntrms)';
fp=polyval(flipud(c),zeta);

% Evaluate stresses relative to the curvilinear 
% coordinate system 
tcplx=zeta./abs(zeta.*zp).*(fp-i*conj(z).*zp);

% trho is the radial shear stress that should 
% vanish at the boundary
trho=real(tcplx);

% talpha is the circumferential stress which 
% gives the maximum stress of interest at the 
% boundary
talpha=-imag(tcplx);

%=============================================

function [z,zp]=mapsqr(zeta); 
%
% [z,zp]=mapsqr(zeta)
% ~~~~~~~~~~~~~~~~~~~
%
% This function maps the interior of a circle
% onto the interior of a square using a rational 
% function of the approximate form:
%
% z(zeta)=zeta*Sum(a(j)* ...
%         zeta4^(j-1)/(1+Sum(b(j)*zeta4^(j-1))
%
% where zeta4=zeta^4
%
% zeta - matrix of complex values such that 
%        abs(zeta)<=1
% z,zp - matrices of values of the mapping 
%        function and its first derivative
%
% User m functions called:  none
%----------------------------------------------

a=[ 1.07835,  1.37751, -0.02642, -0.09129, ...
    0.13460, -0.15763,  0.07430,  0.14858, ...
    0.01878, -0.00354 ]'; 
b=[ 1.37743,  0.07157, -0.11085,  0.12778, ...
   -0.13750,  0.05313,  0.14931,  0.02683, ...
   -0.00350, -0.000120 ]';

% Evaluate the mapping function
zeta4=zeta.^4; p=zeta.*polyval(flipud(a),zeta4);
q=polyval(flipud([1;b]),zeta4); z=p./q;

% Exit if the derivative of z is not needed
if nargout==1, return, end

% evaluate z'(zeta)
na=length(a); nb=length(b);
pp=polyval(flipud((4*(1:na)'-3).*a),zeta4);
qp=4*zeta.^3.*polyval(flipud((1:nb)'.*b),zeta4);
zp=(q.*pp-p.*qp)./q.^2; 
