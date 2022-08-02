num = 20;
den = [conv([1 0.05],[1 0.1]) 0];
w = logspace(-3,1);
[g p] = bode(num,den,w); g = 20*log10(g);
axis([-270 -90 -10 120]); plot(p,g); grid; axis([-270 -90 -10 120]);
xlabel('Phase (degrees)'); ylabel('Gain (db)');
dm = linspace(.01,.9999);
%n = (2/pi)*(pi/2-dm.*cos(asin(dm))-asin(dm)); nn = (0*n-1)./n;
n = dead_zn(linspace(.01,.9999)); nn = (0*n-1)./n;
hold on; plot(0*nn-180,20*log10(abs(nn)),'g--'); hold off;
%
w=[.01 .03 .05 .2 .5 1 2 3.9]; [g p]=bode(num,den,w); g=20*log10(g);
hold on; plot(p,g,'*'); hold off;
for ii=1:length(w);
  text(p(ii),g(ii)-1,[' W=' num2str(w(ii))]);
end;
%
dm = [.9997 .997 .995 .99 .98 .95 .9 .8 .6 .1];
n = dead_zn(dm); nn = (0*n-1)./n; nnm = 20*log10(nn);
hold on; plot(0*nn-180,20*log10(abs(nn)),'g*'); hold off;
for ii = 1:length(dm);
  text(-180,nnm(ii)-1,[' D/M=' num2str(dm(ii))]);
end;
%
nm = polysbst(num,[sqrt(-1) 0]); dn = polysbst(den,[sqrt(-1) 0]);
%
dm = crosser('dead_zn',[.997 .9997],[],[],nm,dn);
n = dead_zn(dm); nn = -1/n; nnm = 20*log10(nn);
hold on; plot(-180,nnm,'g*'); hold off;
w = polyangl(nm,dn,-180);
ii = find(real(w) > 0); w = real(w(ii));
text(-180,nnm-1,[' D/M=' num2str(dm) ', W=' num2str(w)]);
