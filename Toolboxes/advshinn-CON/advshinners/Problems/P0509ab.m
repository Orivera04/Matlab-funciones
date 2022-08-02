clf; sbplot(211);
num = 25;
den = [conv([0.05 1],[0.1 1]) 0];
w = logspace(0,1.2);
[g p] = bode(num,den,w); g = 20*log10(g);
axis([-180 -90 -10 30]); plot(p,g); grid; hold on;
title('Part A'); xlabel('Phase (degrees)'); ylabel('Gain (db)');
n = back_lsh(linspace(.01,.95)); nn = (0*n-1)./n;
nnm = 20*log10(abs(nn)); nnp = imag(log(nn))*180/pi;
plot(nnp,nnm,'g--');
%
w=[1 4 6 8 10]; [g p]=bode(num,den,w); g=20*log10(g);
plot(p,g,'*');
for ii=1:length(w);
  text(p(ii),g(ii)-1,[' W=' num2str(w(ii))]);
end;
%
 dm = [.95 .8 .6 .4]; n = back_lsh(dm); nn = (0*n-1)./n;
 nnm = 20*log10(abs(nn)); nnp = imag(log(nn))*180/pi;
plot(nnp,nnm,'g*');
for ii = 1:length(dm);
  text(nnp(ii),nnm(ii)-1,[' D/M=' num2str(dm(ii))]);
end;
%
nm = polysbst(num,[sqrt(-1) 0]); dn = polysbst(den,[sqrt(-1) 0]);
%
dm=crosser('back_lsh',[.8 .95],0,[],nm,dn);
n=back_lsh(dm); nnm=20*log10(abs(1/n)); nnp=imag(log(-1/n))*180/pi;
plot(nnp,nnm,'*y');
w = polymag(nm,dn,abs(1/n));
ii = find(real(w) > 0); w = real(w(ii));
text(nnp,nnm-1,[' D/M=' num2str(dm) ', W=' num2str(w)]);
%
dm=crosser('back_lsh',[.05 .2],0,[],nm,dn);
n=back_lsh(dm); nnm=20*log10(abs(1/n)); nnp=imag(log(-1/n))*180/pi;
plot(nnp,nnm,'*y');
w = polymag(nm,dn,abs(1/n));
ii = find(real(w) > 0); w = real(w(ii));
text(nnp,nnm-1,[' D/M=' num2str(dm) ', W=' num2str(w)]);
%
%
hold off; sbplot(212);
num = 16.714;
den = [conv([0.05 1],[0.1 1]) 0];
w = logspace(0,1.2);
[g p] = bode(num,den,w); g = 20*log10(g);
axis([-180 -90 -10 30]); plot(p,g); grid; hold on;
title('Part B'); xlabel('Phase (degrees)'); ylabel('Gain (db)');
n = back_lsh(linspace(.01,.95)); nn = (0*n-1)./n;
nnm = 20*log10(abs(nn)); nnp = imag(log(nn))*180/pi;
plot(nnp,nnm,'g--');
%
w=[1 3 5 8 12]; [g p]=bode(num,den,w); g=20*log10(g);
plot(p,g,'*');
for ii=1:length(w);
  text(p(ii),g(ii)-1,[' W=' num2str(w(ii))]);
end;
%
 dm = [.9 .8 .3 .1]; n = back_lsh(dm); nn = (0*n-1)./n;
 nnm = 20*log10(abs(nn)); nnp = imag(log(nn))*180/pi;
plot(nnp,nnm,'g*');
for ii = 1:length(dm);
  text(nnp(ii),nnm(ii)-1,[' D/M=' num2str(dm(ii))]);
end;
%
nm = polysbst(num,[sqrt(-1) 0]); dn = polysbst(den,[sqrt(-1) 0]);
%
dm=fmins('back_lsh',.6,[],[],nm,dn);
n=back_lsh(dm); nnm=20*log10(abs(1/n)); nnp=imag(log(-1/n))*180/pi;
plot(nnp,nnm,'*y');
w = polymag(nm,dn,abs(1/n));
ii = find(real(w) > 0); w = real(w(ii));
text(nnp,nnm-1,[' D/M=' num2str(dm) ', W=' num2str(w)]);
hold off;
