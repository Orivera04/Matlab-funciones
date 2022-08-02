num = 1.5;
den = [conv([1 1],[1 1]) 0];
w = logspace(-1,0);
[g p] = bode(num,den,w); g = 20*log10(g);
axis([-180 -90 -10 25]); plot(p,g,'b-',[-176 -167],[13.5 13.5],'b-'); grid;
text(-165,13.5,'GH');
xlabel('Phase (degrees)'); ylabel('Gain (db)');
n = back_lsh(linspace(.001,.95)); nn = (0*n-1)./n;
nnm = 20*log10(abs(nn)); nnp = angle(nn)*180/pi;
hold on; plot(nnp,nnm,'g--',[-176 -167],[11.5 11.5],'g--'); hold off;
text(-165,11.5,'-1/N');
%
w=[.1 .45 .6 1]; [g p]=bode(num,den,w); g=20*log10(g);
hold on; plot(p,g,'*'); hold off;
for ii=1:length(w);
  text(p(ii),g(ii)-1,[' W=' num2str(w(ii))]);
end;
%
 dm = [.9 .75 .6 .4]; n = back_lsh(dm); nn = (0*n-1)./n;
 nnm = 20*log10(abs(nn)); nnp = angle(nn)*180/pi;
 dm = [dm 0]; nnp = [nnp -180]; nnm = [nnm 0]; % dm=0 value
hold on; plot(nnp,nnm,'g*'); hold off;
for ii = 1:length(dm);
  text(nnp(ii),nnm(ii)-1,[' D/M=' num2str(dm(ii))]);
end;
%
nm = polysbst(num,[sqrt(-1) 0]); dn = polysbst(den,[sqrt(-1) 0]);
%
dm=crosser('back_lsh',[.75 .9],[],[],nm,dn);
n=back_lsh(dm); nnm=20*log10(abs(1/n)); nnp=angle(-1/n)*180/pi;
hold on; plot(nnp,nnm,'*'); hold off;
w = polymag(nm,dn,abs(1/n));
ii = find(real(w) > 0); w = w(ii);
text(nnp,nnm-1,[' D/M=' num2str(dm) ', W=' num2str(w)]);
%
dm=crosser('back_lsh',[.01 .4],[],[],nm,dn);
n=back_lsh(dm); nnm=20*log10(abs(1/n)); nnp=angle(-1/n)*180/pi;
hold on; plot(nnp,nnm,'*'); hold off;
w = polymag(nm,dn,abs(1/n));
ii = find(real(w) > 0); w = w(ii);
text(nnp,nnm-1,[' D/M=' num2str(dm) ', W=' num2str(w)]);
