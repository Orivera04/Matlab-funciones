num = 10;
den = [1 4 0];
w = logspace(0,2);
[g p] = bode(num,den,w); g = 20*log10(g);
axis([-180 -120 -40 0]); plot(p,g); grid; axis([-180 -120 -40 0]);
xlabel('Phase (degrees)'); ylabel('Gain (db)');
d=0.01; h=0.02; m=logspace(log10(d+h),log10(1.5));
n = relays(m,h,d);
nn = (0*n-1)./n; nnp = unwrap(imag(log(nn)))*180/pi; nnm = abs(nn);
hold on; plot(nnp,20*log10(nnm),'g--'); hold off;
%
w=[3 4 5 7 10 12 20 25 30]; [g p]=bode(num,den,w); g=20*log10(g);
hold on; plot(p,g,'*'); hold off;
for ii=1:length(w);
  text(p(ii),g(ii)-0.5,[' W=' num2str(w(ii))]);
end;
%
m = [1 .2 .3 .5 .1 .07 .03];
n = relays(m,h,d); nn = (0*n-1)./n;
nnp = unwrap(imag(log(nn)))*180/pi; nnm = 20*log10(abs(nn));
hold on; plot(nnp,nnm,'g*'); hold off;
for ii = 1:length(m);
  text(nnp(ii),nnm(ii)-0.5,[' M=' num2str(m(ii))]);
end;
%
nm = polysbst(num,[sqrt(-1) 0]); dn = polysbst(den,[sqrt(-1) 0]);
numden = [zeros(1,length(dn)-length(nm)),nm; dn];
%
m = crosser('relays',[.07 .03],[],[],h,d,nm,dn);
n = relays(m,h,d);
nn = -1/n; nnp = imag(log(nn))*180/pi; nnm = 20*log10(abs(nn));
hold on; plot(nnp,nnm,'g*'); hold off;
w = polymag(nm,dn,abs(nn));
w = real(w(find(real(w) > 0))); % only positive real frequencies
text(nnp,nnm-0.5,[' M=' num2str(m) ',W =' num2str(w)]);
