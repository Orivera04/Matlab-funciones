clf; sbplot(211);
num = 20;
den = [conv([0.5 1],[0.5 1]) 0];
w = logspace(-3,1);
[g p] = bode(num,den,w); g = 20*log10(g);
axis([-225 -45 -20 70]); plot(p,g); grid; axis([-225 -45 -20 70]);
title('Part A'); xlabel('Phase (degrees)'); ylabel('Gain (db)');
n = back_lsh([linspace(.01,.99) linspace(.99,.9999,100)]); nn = (0*n-1)./n;
nnm = 20*log10(abs(nn)); nnp = imag(log(nn))*180/pi;
hold on; plot(nnp,nnm,'g--'); hold off;
%
w=[.01 .5 1 2 4]; [g p]=bode(num,den,w); g=20*log10(g);
hold on; plot(p,g,'*'); hold off;
for ii=1:length(w);
  text(p(ii),g(ii)-1,[' W=' num2str(w(ii))]);
end;
%
 dm = [.95 .8 .6 .4 .1]; n = back_lsh(dm); nn = (0*n-1)./n;
 nnm = 20*log10(abs(nn)); nnp = imag(log(nn))*180/pi;
hold on; plot(nnp,nnm,'g*'); hold off;
for ii = 1:length(dm);
  text(nnp(ii),nnm(ii)-1,[' D/M=' num2str(dm(ii))]);
end;
%
nm = polysbst(num,[sqrt(-1) 0]); dn = polysbst(den,[sqrt(-1) 0]);
%
dm=crosser('back_lsh',[.95 .999],0,1e-4,nm,dn);
n=back_lsh(dm); nnm=20*log10(abs(1/n)); nnp=imag(log(-1/n))*180/pi;
hold on; plot(nnp,nnm,'*'); hold off;
w = polymag(nm,dn,abs(1/n));
ii = find(real(w) > 0); w = w(ii);
text(nnp,nnm-1,[' D/M=' num2str(dm) ', W=' num2str(w)]);
%
%
hold off; sbplot(212);
num = 1.2;
den = [conv([0.5 1],[0.5 1]) 0];
w = logspace(-4,1);
[g p] = bode(num,den,w); g = 20*log10(g);
axis([-225 -45 -20 70]); plot(p,g); grid; axis([-225 -45 -20 70]);
title('Part B'); xlabel('Phase (degrees)'); ylabel('Gain (db)');
n = back_lsh([linspace(.01,.99) linspace(.99,.9999,100)]); nn = (0*n-1)./n;
nnm = 20*log10(abs(nn)); nnp = imag(log(nn))*180/pi;
hold on; plot(nnp,nnm,'g--'); hold off;
%
w=[.01 .5 1 2]; [g p]=bode(num,den,w); g=20*log10(g);
hold on; plot(p,g,'*'); hold off;
for ii=1:length(w);
  text(p(ii),g(ii)-1,[' W=' num2str(w(ii))]);
end;
%
 dm = [.98 .9 .8 .5 .1]; n = back_lsh(dm); nn = (0*n-1)./n;
 nnm = 20*log10(abs(nn)); nnp = imag(log(nn))*180/pi;
hold on; plot(nnp,nnm,'g*'); hold off;
for ii = 1:length(dm);
  text(nnp(ii),nnm(ii)-1,[' D/M=' num2str(dm(ii))]);
end;
