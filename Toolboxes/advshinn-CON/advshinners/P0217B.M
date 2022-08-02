num = 10*conv(conv([.05 1],[.05 1]),[1/1.67 1]);
den = [conv(conv([.01 1],[10 1]),[1/25 1/5 1]) 0];
w = logspace(-2,3);
[mag ph] = bode(num,den,w); db = 20*log10(mag);
[gm,pm,wcg,wcp] = margins(num,den); gmdb = 20*log10(gm);
%
clf; hold off; sbplot(211);
semilogx(w,db,'-',w,0*w,'-'); grid; frz_axis; hold on;
ylabel('GAIN (DB)'); xlabel('FREQUENCY (RAD/SEC)');
semilogx([wcp wcp],[0 -200],'-b');
text(wcp,0,['W = ' num2str(wcp)]);
for ii = 1:length(gm),
  semilogx(wcg(ii)*[1 1],[-gmdb(ii) 0],'-b');
  text(wcg(ii),-gmdb(ii),[' G.M. = ' num2str(gmdb(ii))]);
end;
%
hold off; sbplot(212);
semilogx(w,ph,'-',w,0*w-180,'-'); grid; frz_axis; hold on;
ylabel('PHASE (DEGREES)'); xlabel('FREQUENCY (RAD/SEC)');
for ii = 1:length(gm),
  semilogx(wcg(ii)*[1 1],[-180 -5000],'-b');
  text(wcg(ii),-180,['W = ' num2str(wcg(ii))]);
end;
semilogx([wcp wcp],[0 pm]-180,'-b');
text(wcp,pm-180,['P.M. = ' num2str(pm)]);
hold off;
