 function realaxis = rlaxis(num,den);
% RLAXIS : Calcuate the portion of the root locus on the real axis
%
%function realaxis = rlaxis(num,den);
%
% Returns the portion of the root locus that is on the real axis
% realaxis is returned as matched pairs [from start, to end]
num = poly_add(num,[]); den = poly_add(den,[]); % remove leading zeros
pz = [roots(num); roots(den)];
ii = find(100*abs(imag(pz)) <= abs(real(pz)));
pz = sort(real(pz(ii)));   % only real axis poles and zeros
if (sign(num(1)) == sign(den(1))),
  if (rem(length(pz),2) == 1); pz = [-Inf; pz]; end;
else
  if (rem(length(pz),2) == 1); pz = [pz; Inf]; end;
end;
realaxis = reshape(pz,2,length(pz)/2)';
