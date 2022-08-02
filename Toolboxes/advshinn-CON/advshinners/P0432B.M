num = conv(conv([-1/4 1],[1/47.6 1]),[0.5 1]);
den = conv([1/0.98 1 0],[0.05 1]);
w = logspace(-2,2);
[mag ph] = bode(num,den,w); db = 20*log10(mag);
[gm,pm,wcg,wcp] = margins(num,den); gmdb = 20*log10(gm);
ii = find(wcg < 1e+8); gm = gm(ii); wcg = wcg(ii); gmdb = gmdb(ii);
%
clf; hold off; sbplot(211);
semilogx(w,db,'-',w,0*w,'-'); grid; frz_axis; hold on;
ylabel('GAIN (DB)'); xlabel('FREQUENCY (RAD/SEC)');
semilogx([wcp wcp],[0 -200],'-b');
text(wcp,0,['W = ' num2str(wcp)]);
semilogx([wcg wcg],[-gmdb 0],'-b');
text(wcg,-gmdb,[' G.M. = ' num2str(gmdb)]);
%
hold off; sbplot(212);
semilogx(w,ph,'-',w,0*w-180,'-'); grid; frz_axis; hold on;
ylabel('PHASE (DEGREES)'); xlabel('FREQUENCY (RAD/SEC)');
semilogx([wcg wcg],[-180 -5000],'-b');
text(wcg,-180,['W = ' num2str(wcg)]);
semilogx([wcp wcp],[0 pm]-180,'-b');
text(wcp,pm-180,['P.M. = ' num2str(pm)]);
hold off;
