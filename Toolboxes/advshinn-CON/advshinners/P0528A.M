num = 4*[5 1]; den = [conv([1.67 1],[1.67 1]) 0];
w = logspace(-2,1);
%
[g p] = bode(num,den,w); g = 20*log10(g);
axis([-180 -80 -10 30]); plot(p,g); grid; axis([-180 -80 -10 30]);
xlabel('Phase (degrees)'); ylabel('Gain (db)');
n = back_lsh(linspace(.01,.99)); nn = (0*n-1)./n;
nnm = 20*log10(abs(nn)); nnp = imag(log(nn))*180/pi;
hold on; plot(nnp,nnm,'g--'); hold off;
%
w=[.5 1 1.3 1.7 3 4]; [g p]=bode(num,den,w); g=20*log10(g);
hold on; plot(p,g,'*'); hold off;
for ii=1:length(w);
  text(p(ii),g(ii)-1,[' W=' num2str(w(ii))]);
end;
%
dm = [.95 .8 .7 .1]; n = back_lsh(dm); nn = (0*n-1)./n;
nnm = 20*log10(abs(nn)); nnp = imag(log(nn))*180/pi;
hold on; plot(nnp,nnm,'g*'); hold off;
for ii = 1:length(dm);
  text(nnp(ii),nnm(ii)-1,[' D/M=' num2str(dm(ii))]);
end;
%
nm = polysbst(num,[sqrt(-1) 0]); dn = polysbst(den,[sqrt(-1) 0]);
%
dm=crosser('back_lsh',[.8 .95],[],[],nm,dn);
n=back_lsh(dm); nnm=20*log10(abs(1/n)); nnp=imag(log(-1/n))*180/pi;
hold on; plot(nnp,nnm,'*'); hold off;
w = polymag(nm,dn,abs(1/n));
ii = find(real(w) > 0); w = real(w(ii));
text(nnp,nnm-1,[' D/M=' num2str(dm) ',']);
text(nnp,nnm-1-1.5,[' W=', num2str(w)]);
%
dm=crosser('back_lsh',[.1 .7],[],[],nm,dn);
n=back_lsh(dm); nnm=20*log10(abs(1/n)); nnp=imag(log(-1/n))*180/pi;
hold on; plot(nnp,nnm,'*'); hold off;
w = polymag(nm,dn,abs(1/n));
ii = find(real(w) > 0); w = real(w(ii)); w = w(1);
text(nnp,nnm-1,[' D/M=' num2str(dm) ', W=' num2str(w)]);
