 function [wp,mp] = wpmp(gnum,gden,hnum,hden);
% WPMP : Calculate the closed loop maximum frequency location
%
%function [wp,mp] = wpmp(num,den);
%function [wp,mp] = wpmp(gnum,gden,hnum,hden);
%
%  find the closed loop Wp and Mp Analytically.
%  default : H(s) = 1 (Unity negative feedback)
 if ( nargin < 3 ); hnum = 1; hden = 1; end; 
% Apply num/den = (Gnum/Gden)/[1+(Gnum/Gden)*(Hnum/Hden)]
 num = conv(gnum,hden);
 den = poly_add(conv(gnum,hnum),conv(gden,hden));
% Transform from the S domain to the JW domain
 [num,den] = polysbst(gnum,den,[sqrt(-1) 0],1);
% get the magnitude squared
 num = conv(num,conj(num)); den = conv(den,conj(den));
% set the numerator of the derivative to 0, and solve for w
 [dnum,dden] = polyder(num,den); w = roots(dnum);
% find the w which is the true maximum
 w = w(find(real(w) > 0)); % eliminate negative/zero frequency
 w = real(w);  % true w is a real value (eliminate imag. part)
 val = sqrt(abs(polyval(num,w)./polyval(den,w)));
 mp = max(val); wp = w(find(val == mp));
