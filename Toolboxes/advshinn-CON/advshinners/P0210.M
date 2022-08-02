num = 5; den = [1 0]; w = logspace(-1,2);
[mag ph] = bode(num,den,w); db = 20*log10(mag);
[gm,pm,wcg,wcp] = margins(num,den); gmdb = 20*log10(gm);
ph = ph-0.2*w'*180/pi; pm = pm-0.2*wcp*180/pi;  % time delay factor
wcg = crosses(w,crossing(ph,-180));
[mag2,ph2] = bode(num,den,wcg); gmdb = -20*log10(mag2);
%
clf; hold off; sbplot(211);
semilogx(w,db,'-',w,0*w,'-'); grid;
ylabel('GAIN (DB)'); xlabel('FREQUENCY (RAD/SEC)');
hold on; semilogx([wcp wcp],[0 -50],'-b'); hold off;
text(wcp,0,['W = ' num2str(wcp)]);
hold on; semilogx([wcg wcg],[-gmdb 0],'-b'); hold off;
text(wcg,-gmdb,[' G.M. = ' num2str(gmdb)]);
%
hold off; sbplot(212);
axis([-1 2 -270 -90]); semilogx(w,ph,'-',w,0*w-180,'-'); grid;
ylabel('PHASE (DEGREES)'); xlabel('FREQUENCY (RAD/SEC)');
hold on; semilogx([wcg wcg],[-180 -5000],'-b'); hold off;
text(wcg,-180,['W = ' num2str(wcg)]);
hold on; semilogx([wcp wcp],[0 pm]-180,'-b'); hold off;
text(wcp,pm-180,['P.M. = ' num2str(pm)]);
frz_axis([-1 2 -270 -90],1);
