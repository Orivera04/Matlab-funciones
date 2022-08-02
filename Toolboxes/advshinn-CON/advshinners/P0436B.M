num = [1 0.5];
den = [1 -1];
zeta = 0.7; theta = 36;
disp(['For Zeta = ' num2str(zeta) ' & theta = ' num2str(theta)]);
z = exp(theta*pi/180*(sqrt(-1)-tan(asin(zeta))));
disp(['Z = ' num2str(real(z)) '+' num2str(imag(z)) 'j']);
a = polyval(num,z); b = -polyval(den,z)*[1 z];
c = roots(real(b)*imag(a)-imag(b)*real(a));
k = polyval(real(b),c)/real(a);
disp('Lead Network { D(z) } introduced :');
if ( exist('printsys') ) % MATLABs' Control System Toolbox
  eval('printsys([1 -1],[1 c],''z'');'); disp('');
else
  disp('num ='); disp([1 -1]); disp('den ='); disp([1 c]); disp('');
end;
disp(['With K (at Zeta and theta) evaluating to ' num2str(k)]);
den = conv(den,[1  c]);
%
[kbreak,sbreak] = rlpoba(num,den);
r = rlocus(num,den,sort([kbreak' linspace(0,10) 5e-2 1e+5]));
axis([-2 1.5 -1.2 1.2]); plot(r,'-'); axis([-2 1.5 -1.2 1.2]);
if ( exist('pzmap') ) % The MATLABs' Control System Toolbox
  hold on; eval('pzmap(num,den);'); hold off;
else
  numroot = roots(num); denroot = roots(den);
  hold on; plot(real(numroot),imag(numroot),'go'); hold off;
  hold on; plot(real(denroot),imag(denroot),'rx'); hold off;
end;
hold on; plot(z,'*b'); hold off;
text(real(z),imag(z),[' K = ' num2str(k)]);
hold on; plot([0 exp(2+sqrt(-1)*theta*pi/180)],'--'); hold off;
text(2.2*real(z),2.2*imag(z),['  ' num2str(theta) ' Degrees']);
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
[kmax,smax] = rootmag(num,den,1);
ii = find(imag(smax) > 1e-3); kmax = kmax(ii); smax = smax(ii);
hold on; plot([smax; conj(smax)],'*g'); hold off;
for ii = 1:length(kmax)
  sr = real(smax(ii)); si = imag(smax(ii));
  text(sr,si,[' Kmax = ' num2str(kmax(ii))]);
  text(sr,-si,[' Smax = ' num2str(sr) num2str(-si) 'j']);
end;
