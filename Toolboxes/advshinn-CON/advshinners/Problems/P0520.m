num = 2;
den = [1 0.1 0];
w = logspace(-1,1);
[g p] = bode(num,den,w); g = 20*log10(g);
axis([-185 -140 -10 40]); plot(p,g); grid; axis([-185 -140 -10 40]);
xlabel('Phase (degrees)'); ylabel('Gain (db)');
dm = linspace(.01,.99); n = dead_zn(dm); nn = (0*n-1)./n;
hold on; plot(0*nn-180,20*log10(abs(nn)),'g--'); hold off;
%
w=[.2 .3 .5 .65 .9 1.2 2 2.5]; [g p]=bode(num,den,w); g=20*log10(g);
hold on; plot(p,g,'*'); hold off;
for ii=1:length(w);
  text(p(ii),g(ii)-1,[' W=' num2str(w(ii))]);
end;
%
dm = [.95 .9 .8 .6 .4 .1]; n = dead_zn(dm); nn = (0*n-1)./n;
hold on; plot(0*nn-180,20*log10(abs(nn)),'g*'); hold off;
for ii = 1:length(dm);
  text(-180,20*log10(abs(nn(ii)))-1,[' D/M=' num2str(dm(ii))]);
end;
