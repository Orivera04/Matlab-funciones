num = 4*[0.9 1]; den = conv([conv([1 1],[1 2]) 0],[0.4 1]);
w = logspace(-2,2);
%
[g p] = bode(num,den,w); g = 20*log10(g);
axis([-200 -80 -10 30]); plot(p,g); grid; axis([-200 -80 -10 30]);
xlabel('Phase (degrees)'); ylabel('Gain (db)');
n = back_lsh(linspace(.01,.99)); nn = (0*n-1)./n;
nnm = 20*log10(abs(nn)); nnp = imag(log(nn))*180/pi;
hold on; plot(nnp,nnm,'g--'); hold off;
%
w=[.1 .2 .35 .55 .75 1 1.5 2]; [g p]=bode(num,den,w); g=20*log10(g);
hold on; plot(p,g,'*'); hold off;
for ii=1:length(w);
  text(p(ii),g(ii)-1,[' W=' num2str(w(ii))]);
end;
%
dm = [.95 .9 .8 .7 .55 .3 .1]; n = back_lsh(dm); nn = (0*n-1)./n;
nnm = 20*log10(abs(nn)); nnp = imag(log(nn))*180/pi;
hold on; plot(nnp,nnm,'g*'); hold off;
for ii = 1:length(dm);
  text(nnp(ii),nnm(ii)-1,[' D/M=' num2str(dm(ii))]);
end;
