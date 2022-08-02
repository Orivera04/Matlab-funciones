num = 4*conv([5 1],[1.08 1]);
den = conv([conv([1.67 1],[1.67 1]) 0],[0.36 1]);
w = logspace(-2,1);
[g p] = bode(num,den,w); g = 20*log10(g);
axis([-180 -80 -10 30]); plot(p,g); grid; axis([-180 -80 -10 30]);
xlabel('Phase (degrees)'); ylabel('Gain (db)');
n = back_lsh(linspace(.01,.99)); nn = (0*n-1)./n;
nnm = 20*log10(abs(nn)); nnp = imag(log(nn))*180/pi;
hold on; plot(nnp,nnm,'g--'); hold off;
%
w=[1.3 2 3 4 5 7]; [g p]=bode(num,den,w); g=20*log10(g);
hold on; plot(p,g,'*'); hold off;
for ii=1:length(w);
  text(p(ii),g(ii)-1,[' W=' num2str(w(ii))]);
end;
%
dm = [.95 .9 .8 .65 .4 .1]; n = back_lsh(dm); nn = (0*n-1)./n;
nnm = 20*log10(abs(nn)); nnp = imag(log(nn))*180/pi;
hold on; plot(nnp,nnm,'g*'); hold off;
for ii = 1:length(dm);
  text(nnp(ii),nnm(ii)-1,[' D/M=' num2str(dm(ii))]);
end;
