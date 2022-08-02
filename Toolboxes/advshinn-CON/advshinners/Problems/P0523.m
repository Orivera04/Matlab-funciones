num = 1.4;
den = [1 4 0];
w = logspace(0,2);
[g p] = bode(num,den,w); g = 20*log10(g);
axis([-180 -110 -40 -10]); plot(p,g); grid; axis([-180 -110 -40 -10]);
xlabel('Phase (degrees)'); ylabel('Gain (db)');
d=0.01; h=0.02; m=logspace(log10(d+h),log10(0.4));
n = relays(m,h,d);
nn = (0*n-1)./n; nnp = unwrap(imag(log(nn)))*180/pi; nnm = abs(nn);
hold on; plot(nnp,20*log10(nnm),'g--'); hold off;
%
w=[2 3 4 5 6 7 8 10]; [g p]=bode(num,den,w); g=20*log10(g);
hold on; plot(p,g,'*'); hold off;
for ii=1:length(w);
  text(p(ii),g(ii)-0.5,[' W=' num2str(w(ii))]);
end;
%
m = [.4 .3 .2 .1 .06 .035 .03];
n = relays(m,h,d); nn = (0*n-1)./n;
nnp = unwrap(imag(log(nn)))*180/pi; nnm = 20*log10(abs(nn));
hold on; plot(nnp,nnm,'g*'); hold off;
for ii = 1:length(m);
  text(nnp(ii),nnm(ii)-0.5,[' M=' num2str(m(ii))]);
end;
