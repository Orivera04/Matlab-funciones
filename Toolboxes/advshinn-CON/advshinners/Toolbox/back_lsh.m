 function [n] = back_lsh(dm,num,den);
% BACK_LSH : Describing Function implementation of BACKLASH
%
%function [n] = back_lsh(dm);          % backlash value
%function [n] = back_lsh(dm,num,den);   % solution for backlash
%
%  0 <= dm < 1
%
%SOLUTION :
%  RETURNS the difference of the back_lsh function @ dm, and
%          the polynomial whos magnitude matches (via polymag)
%          the magnitude of the back_lsh function.
%  crosser('back_lsh',range,[],[],num,den) will attempt to find the
%          crossing point of the two curves in the specified range!
a1 = dm.*(2*dm-2)*2/pi;
b1 = (pi/2-asin(2*dm-1)-(2*dm-1).*cos(asin(2*dm-1)))/pi;
n = sqrt(-1)*a1 + b1;
%
if ( nargin > 1 ),      % return the gain difference
  w = polymag(num,den,1/n);
  ii = find(real(w) > 0); w = w(ii); % positive frequency only
  val = polyval(num,w)./polyval(den,w);
  n = val+1/n; n = sign(real(n)).*abs(n);
%  n = (val+1/n); % n = abs(n);
%  if ( abs(imag(w)) > 0 ), n = n^2; end;
end;
