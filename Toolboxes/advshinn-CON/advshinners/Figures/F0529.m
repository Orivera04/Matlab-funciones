num = 1.5*[1.9 1];
den = conv([conv([1 1],[1 1]) 0],[0.65 1]);
w = logspace(log10(.08),log10(1.6));
[g p] = bode(num,den,w); g = 20*log10(g);
axis([-180 -90 -10 25]); plot(p,g,'b-',[-176 -167],[13.5 13.5],'b-');
grid; axis([-180 -90 -10 25]); text(-165,13.5,'G');
xlabel('Phase (degrees)'); ylabel('Gain (db)');
n = back_lsh(linspace(.01,.95)); nn = (0*n-1)./n;
nnm = 20*log10(abs(nn)); nnp = imag(log(nn))*180/pi;
hold on; plot(nnp,nnm,'g--',[-176 -167],[11.5 11.5],'g--'); hold off;
text(-165,11.5,'-1/N');
%
w=[.1 .3 .6 .9 1.1 1.3 1.5]; [g p]=bode(num,den,w); g=20*log10(g);
hold on; plot(p,g,'*'); hold off;
for ii=1:length(w);
  text(p(ii),g(ii)-1,[' W=' num2str(w(ii))]);
end;
%
 dm = [.9 .8 .6 .4 .1]; n = back_lsh(dm); nn = (0*n-1)./n;
 nnm = 20*log10(abs(nn)); nnp = imag(log(nn))*180/pi;
 hold on; plot(nnp,nnm,'g*'); hold off;
for ii = 1:length(dm);
  text(nnp(ii),nnm(ii)-1,[' D/M=' num2str(dm(ii))]);
end;
