 function [n] = dead_zn(dm,num,den);
% DEAD_ZN = Describing Function implementation of Dead Zone 
%
%function [n] = dead_zn(dm);
%function [n] = dead_zn(dm,num,den);
%
% Describing Function implementation of Dead Zone 
%  0 <= dm < 1
%
%SOLUTION
%  RETURNS the difference of the dead_zn function @ dm, and the polynomial
%          whos phase matches (via polyangl) the phase of the dead_zn function.
%  crosser('dead_zn',range,[],[],num,den) will attempt to find the crossing 
%          point of the two curves in the specified range!
n = (pi/2-dm.*cos(asin(dm))-asin(dm))*2/pi;
ii = find(dm >= 1); if ( ~isempty(ii) ); n(ii) = abs(eps); end;
ii = find(dm <= 0); if ( ~isempty(ii) ); n(ii) = 1; end;
%
if (nargin > 1),
  w = polyangl(num,den,-180);
  ii = find(real(w) > 0); w = w(ii); % positive frequencies only
  val = polyval(num,w)./polyval(den,w);
  n = real(val+1/n); 
%  n = sign(real(n))*abs(n);
end;
