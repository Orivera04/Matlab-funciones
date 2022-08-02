function b = beam(n,dol,theta)

%function b = beam(n,dol,theta)
%
%To calculate the beam pattern,b, of a phased array
%at angles theta, given the number of hydrophones, n, and
%the spacing in wavelengths, dol.
%(See Urick, "Principles of Underwater Sound ."
%
%                   Andrew Knight, June 1991
%
ind = find(theta==0);
if ~isempty(ind);
   theta(ind) = eps;
end
arg = pi*dol*sin(theta);
b = (sin(n*arg).*cos(arg*(n - 1))./sin(arg)).^2 ./n^2;
