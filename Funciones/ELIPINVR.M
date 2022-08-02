function zeta=elipinvr(a,b,z)
% 
% zeta=elipinvr(a,b,z)
% ~~~~~~~~~~~~~~~~~~~~
%
% This function inverts the transformation
% z=(a+b)/2*zeta+(a-b)/2/zeta which maps 
% abs(zeta)>=1 onto (x/a).^2+(y/b).^2 >= 1
%
%  a    - semi-diameter on x-axis
%  b    - semi-diameter on y-axis
%  z    - array of complex values
%
%  zeta - array of complex values for the 
%         inverse mapping function
%
% User m functions called:  none

z0=sqrt(a^2-b^2); ab=a+b;
if a==b
  zeta=z/a;
elseif a>b  % branch cut along the real axis
  zeta=(z+sqrt(z-z0).*sqrt(z+z0))/ab;
else      % branch cut along the imaginary axis
  ap=angle(z+z0); ap=ap+2*pi*(ap<=-pi/2);
  am=angle(z-z0); am=am+2*pi*(am<=-pi/2);
  zeta=(z+sqrt(abs(z.^2-z0.^2)).*exp(...
        i/2*(ap+am)))/ab;
end