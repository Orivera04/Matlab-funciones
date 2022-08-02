num = 10;
den = [1 1 0];
w = logspace(-1,2);
[g p] = bode(num,den,w); g = 20*log10(g);
axis([-185 -90 -30 30]); plot(p,g); grid; axis([-185 -90 -30 30]);
xlabel('Phase (degrees)'); ylabel('Gain (db)');
m=logspace(-2,2); nn = -pi*m/(4*1);
hold on; plot(0*nn-180,20*log10(abs(nn)),'g--'); hold off;
%
w=[.4 .7 1 1.5 2 3 4 6 10 13]; [g p]=bode(num,den,w); g=20*log10(g);
hold on; plot(p,g,'*'); hold off;
for ii=1:length(w);
  text(p(ii),g(ii)-1,[' W=' num2str(w(ii))]);
end;
%
m = [30 10 5 2 1 .5 .2 .1 .05]; nnm = 20*log10(pi*m/4);
hold on; plot(0*m-180,nnm,'g*'); hold off;
for ii = 1:length(m);
  text(-180,nnm(ii)-1,[' M=' num2str(m(ii))]);
end;
%
nm = polysbst(num,[sqrt(-1) 0]); dn = polysbst(den,[sqrt(-1) 0]);
numden = [zeros(1,length(dn)-length(nm)),nm; dn];
%
%w = polyangl(nm,dn,-180);
%ii = find(real(w) > 0); w = real(w(ii)); % only positive real freq.
%val = polyval(nm,w)./polyval(dn,w); val = abs(val);
%hold on; plot(0*w-180,20*log10(val),'g*'); hold off;
%m = pi*abs(val)/4;
%text(-180,20*log10(val)-1,[' M=' num2str(m) ', W=' num2str(w)]);
