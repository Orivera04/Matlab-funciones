clf; hold off; sbplot(211);
num = [1 1];
den = [1 8 16 0];
[kbreak sbreak] = rlpoba(num,den);
[kmax,smax] = rootangl(num,den,90);
r = rlocus(num,den,sort([0 kbreak' kmax' logspace(-1,4)]));
axis([-5 1 -13 13]); plot(r,'-'); grid; axis([-5 1 -13 13]);
xlabel('Real'); ylabel('Imaginary');
hold on; plot(real(roots(num)),imag(roots(num)),'o'); hold off;
hold on; plot(real(roots(den)),imag(roots(den)),'x'); hold off;
angle = acos(-0.3)*180/pi;   % angle at which zeta = 0.3
[ka sa] = rootangl(num,den,angle);
hold on; plot(sa,'*b'); hold off;
for ii = 1:length(ka)
  text(real(sa(ii)),imag(sa(ii)),[' K = ' num2str(ka(ii))]);
  hold on; plot([0 sa(ii)],'--'); hold off;
end;
%
sbplot(212);
g=[-360 0 -24 36]; goeu=g;
a=-[.25:.25:1 2 5 10:10:170 179.99]; aoeu=a;
b=[-24 -18 -12 -9 -7 -5 -3:-1 -.25:.25:.5 1:3 5 9 18]; boeu=b;
nichgrid(g,a,b,3);
a=-.25;
gain = exp(b*log(10)/20+sqrt(-1)*a*pi/180); gain = gain./(1-gain);
gaindb=20*log10(abs(gain)); gainph=imag(log(gain))*180/pi;
for ii=1:length(b)
  text(gainph(ii)-12,min(g(4)-2,gaindb(ii)),[num2str(b(ii)) 'db']);
end;
b=-24; a=[-179.99 -150 -120 -90 -60 -30];
gain = exp(b*log(10)/20+sqrt(-1)*a*pi/180); gain = gain./(1-gain);
a(1) = -180;
for ii=1:length(a)
  text(imag(log(gain(ii)))*180/pi-7,g(3),num2str(a(ii)));
  text(-360-imag(log(gain(ii)))*180/pi-7,g(3),num2str(-360-a(ii)));
end;
%
num = ka*num;
w = logspace(-1,2); [gain phase] = bode(num,den,w);
hold on; plot(phase,20*log10(gain),'g-'); hold off;
%
w = [0.2 1 3 5 7 15:5:30]; [gain phase] = bode(num,den,w);
hold on; plot(phase,20*log10(gain),'r*'); hold off;
for ii=1:length(w);
  text(phase(ii)+5,20*log10(gain(ii))-1,['W = ' num2str(w(ii))]);
end;
%
[wp mp] = wpmp(num,den); mp = 20*log10(mp);
m = polyval(num,sqrt(-1)*wp)./polyval(den,sqrt(-1)*wp);
mph = imag(log(m))*180/pi;
mdb = 20*log10(abs(m));
hold on; plot(mph,mdb,'*b'); hold off;
text(mph+5,mdb-1,['Wp = ' num2str(wp) ', Mp = ' num2str(mp) 'db']);
