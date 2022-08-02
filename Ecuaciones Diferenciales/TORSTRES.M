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
%          of the complex stress funtion
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

% trho is the radial shear stress which should 
% vanish at the boundary
trho=real(tcplx);

% talpha is the circumferential stress which 
% gives the maximum stress of interest at the 
% boundary
talpha=-imag(tcplx);
