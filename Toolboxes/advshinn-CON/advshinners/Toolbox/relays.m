 function [nd] = relays(dm,hd,d,num,den);
% RELAYS : Describing Function implementation of Hysterisys Type Elements
%
%function [n] = relays(m,h,d);
%function [n] = relays(m,h,d,num,den);
% or
%OPTIONAL implementation: function [nd] = relays(dm,hd);
%                         nd = n*d, dm = d/m, hd = h/d !!! REQ: dm >= 1/(1+hd)
%
% Describing Function implementation of Hysterisys Type Elements
%
%SOLUTION :
%  RETURNS the difference of the relays funtion @ dm, and the polynomial whos
%          magnitude matches (via polymag) the magnitude of the relays function.
%  crosser('relays',range,[],[],h,d,num,den) will attempt to find the
%          crossing point of the two curves in the specified range! 
if ( nargin == 2 ), d = 1; else dm = (0*dm+d)./dm; hd = hd/d; end;
%
a1 = (-2/pi)*(hd.*dm);
b1 = (2/pi)*(cos(asin((1+hd).*dm))+cos(asin(dm)));
nd = (sqrt(-1)*a1.*dm + b1.*dm)/d;
%
if ( nargin > 4 ),  % return the gain difference
  w = polyangl(num,den,angle(-1/nd)*180/pi);
  ii = find(real(w) > 0);  w = w(ii);  % positive frequencies only
  val = polyval(num,w)./polyval(den,w);
  nd = val+1/nd;
end;
