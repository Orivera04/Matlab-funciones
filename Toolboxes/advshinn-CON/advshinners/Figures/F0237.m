g=[-360 0 -24 36];
a=-[.25:.25:1 2 5 10:10:170 179.99];
b=[-24 -18 -12 -9 -7 -5:-1 -.5:.25:.5 1:5 7 9 12];
[x,y] = nichgrid(g,a,b,3);
ii = [1 length(a)-3*(0:5)]; a = a(ii); x = x(ii,:); y = y(ii,:);
for ii = 1:length(b)             % label closed-loop gain axis
  text(x(1,ii)-12,min(g(4)-2,y(1,ii)),[num2str(b(ii)) 'db']);
end;
for ii = 2:length(a)             % label closed-loop phase axis
  text(x(ii,1)-7,g(3),num2str(a(ii)));
  text(-360-x(ii,1)-7,g(3),num2str(-360-a(ii)));
end;
%
num = 11.7*[.58 1]; den = conv([conv([0.05 1],[0.1 1]) 0],[1.74 1]);
%
w = [.1:.1:1 2:30 75]; [gain phase] = bode(num,den,w);
hold on; plot(phase,20*log10(gain),'g-'); hold off;
%
w = [0.5 1 2 5 7 9 12 15]; [gain phase] = bode(num,den,w);
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
