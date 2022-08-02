num = [1 0.5];
den = conv([1 -1],[1 -1]);
[kbreak,sbreak] = rlpoba(num,den);
r = rlocus(num,den,sort([kbreak' linspace(0,10) 5e-2 1e+5]));
axis([-3 2 -2 2]); plot(r,'-'); axis([-3 2 -2 2]);
if ( exist('pzmap') ) % MATLABs' Control System Toolbox
  hold on; eval('pzmap(num,den);'); hold off;
else
  numroot = roots(num); denroot = roots(den);
  hold on; plot(real(numroot),imag(numroot),'go'); hold off;
  hold on; plot(real(denroot),imag(denroot),'rx'); hold off;
end;
zeta = [0 .1 .3 .5 .7 .9 1]; wn = (1:10)*pi/10;
if ( exist('zgrid') ) % MATLABs' Control System Toolbox
  eval('zgrid(zeta,wn);');
else
  q = linspace(0,pi); hold on; plot(sin(2*q),cos(2*q),'w-'); hold off;
  z = exp(q'*(tan(asin(-zeta))+sqrt(-1))); zr = real(z); zi = imag(z);
  hold on; plot(zr,zi,'w:',zr,-zi,'w:'); hold off;
end;
[x,y] = meshdom(wn,pi*linspace(1/2,1));
z = exp(x).^exp(sqrt(-1)*y); zr = real(z); zi = imag(z);
hold on; plot(zr,zi,'w:',zr,-zi,'w:'); hold off;

zetav = exp(pi/2*(tan(asin(-zeta))+sqrt(-1)));
zetav(length(zetav)) = 0.2;
for ii = 1:length(zeta)
  text(real(zetav(ii)),imag(zetav(ii)),num2str(zeta(ii)));
end;
hold on; plot(sbreak,0*sbreak,'*b'); hold off;
for ii = 1:length(kbreak)
  text(sbreak(ii),0,[' Kbreak = ' num2str(kbreak(ii))]);
end;
