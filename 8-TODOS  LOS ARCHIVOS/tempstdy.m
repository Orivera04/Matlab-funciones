function [u,z]=tempstdy(theta,r)
%
% [u,z]=tempstdy(theta,r)
% ~~~~~~~~~~~~~~~~~~~~~~
% Steady state temperature distribution in a 
% circular cylinder of unit radius with 
% piecewise linear boundary values 
% described in global array ubdry. 
global ubdry

thft=2*pi/(1024)*(0:1023); n=100; 
ufft=interp1(pi/180*ubdry(:,1),...
             ubdry(:,2)/1024,thft);
c=fft(ufft); z=exp(i*theta(:))*r(:)';
u=-real(c(1))+2*real(...
   polyval(c(n:-1:1),z)); 