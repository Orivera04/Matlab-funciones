 function [k,s] = rootmag(num,den,mag);
% ROOTMAG : Calculate the roots on a given magnitude for the root locus
%
%function [k,s] = rootmag(num,den,mag);
%
mag = abs(mag);
%
% Scale axis to get the Unit circle as the mag boundary
[nm,dn] = polysbst(num,den,[mag 0],1);
%
% Replace S with cos+j*sin, and form a matrix representation
% Then replace sin^2 with 1-cos^2 (reducing to 2 rows> real & imag parts)!!!
nn= length(nm); n= zeros(nn,nn); nd= length(dn); d= zeros(nd,nd);
val = 1; v = [1 sqrt(-1)];
for ii = 1:max([nd nn])
  if ( ii <= nn ),
    for jj = 1:ii; n(jj,1+ii-jj) = nm(1+nn-ii)*val(jj); end;
  end;
  if ( ii <= nd ),
    for jj = 1:ii; d(jj,1+ii-jj) = dn(1+nd-ii)*val(jj); end;
  end;
  val = conv(val,v);
end;
%
rnum = []; inum = []; rden = []; iden = []; val = 1; v = [-1 0 1];
for i = 1:2:max([nn nd])
  if (i <= nn), rnum= poly_add(rnum,conv(val,n(i,nn:-1:1))); end;
  if (i <= nd), rden= poly_add(rden,conv(val,d(i,nd:-1:1))); end;
  if (i+1 <= nn), inum= poly_add(inum,conv(val,n(i+1,nn:-1:1))); end;
  if (i+1 <= nd), iden= poly_add(iden,conv(val,d(i+1,nd:-1:1))); end;
  val = conv(val,v);
end;
%
% Updated for conv to handle empty matrices
% s = roots(poly_add(-conv(iden,rnum),conv(rden,inum))); % real part
if ( isempty(iden) | isempty(rnum) ), r1 = [];
   else r1 = -conv(iden,rnum); end;
if ( isempty(rden) | isempty(inum) ), r2 = [];
   else r2 = conv(rden,inum); end;
s = roots(poly_add(r1,r2)); % real part
s = s(find(abs(s) <= 1.001));  % within the unit circle
s = s(find(abs(real(s)) >= abs(100*imag(s)))); % should be real only
%
% Include imaginary part of s, and add axis crossings for check!
s = mag*[s+sqrt(s.^2-1); s-sqrt(s.^2-1);  1; -1; sqrt(-1)*[1; -1]];
k = -polyval(den,s)./polyval(num,s);
ii = find(real(k) >= -1e-3); s = s(ii); k = k(ii);
ii = find(abs(real(k)) >= 100*abs(imag(k))); s = s(ii); k = k(ii);
k = abs(k);
