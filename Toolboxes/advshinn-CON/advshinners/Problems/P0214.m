num = 99*conv([.2 1],[.1 1]);
den =conv(conv([.1 1],conv([.2 1],[1.5 1])),conv([.01 1],[.005 1]));
w = logspace(-1,4);
[mag ph] = bode(num,den,w); db = 20*log10(mag);
[gm,pm,wcg,wcp] = margins(num,den); gmdb = 20*log10(gm);
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
