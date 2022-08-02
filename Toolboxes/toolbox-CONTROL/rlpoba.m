 function [k,s] = rlpoba(num,den);
% RLPOBA : Calculate the break away/in points of the root locus
%
%function [k,s] = rlpoba(num,den);
%
% Analytically finds the points of break on the real axis.
[n,d] = polyder(-den,num);
s = roots(n);
if (d(length(d)) == 0), s = s(find(s ~= 0)); end;
s = s(find(abs(real(s)) >= 100*abs(imag(s))));          % s is on real axis
s = s(find(polyval(num,s) ~= 0));                       % no divide by zeros!
k = -polyval(den,s)./polyval(num,s);
ii = find(real(k) >= 0); k = real(k(ii)); s = real(s(ii));
