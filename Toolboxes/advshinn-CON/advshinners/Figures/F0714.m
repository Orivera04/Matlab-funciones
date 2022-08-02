num = conv([320],[4.22 1]); den = conv([1 10 0],[23.68 1]);
w = logspace(0,2);
[mag ph] = bode(num,den,w); db = 20*log10(mag);
[gm,pm,wcg,wcp] = margins(num,den); gmdb = 20*log10(gm);
%
clf; hold off; sbplot(211);
semilogx(w,db); grid; frz_axis;
title('BODE DIAGRAM OF COMPENSATED SYSTEM');
ylabel('GAIN (DB)'); xlabel('FREQUENCY (RAD/SEC)');
hold on; semilogx([w(1) wcp wcp],[0 0 -200]); hold off;
text(wcp,0,['W = ' num2str(wcp)]);
%
sbplot(212);
semilogx(w,ph,'-',w,0*w-180,'-'); grid; frz_axis;
%title('BODE DIAGRAM OF COMPENSATED SYSTEM');
ylabel('PHASE (DEGREES)'); xlabel('FREQUENCY (RAD/SEC)');
hold on; semilogx([wcp wcp],[0 pm]-180); hold off;
text(wcp,pm-180,['Phase = ' num2str(pm-180)]);
text(wcp,-180,[' W = ' num2str(wcp)]);
