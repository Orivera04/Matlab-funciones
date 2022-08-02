num = 49*[-1/4 1]; den = [1/0.039 1]; w = logspace(-2,2);
[mag ph] = bode(num,den,w); db = 20*log10(mag);
[gm,pm,wcg,wcp] = margins(num,den); gmdb = 20*log10(gm);
%
clf; hold off; sbplot(211);
semilogx(w,db); grid; frz_axis;
ylabel('GAIN (DB)'); xlabel('FREQUENCY (RAD/SEC)');
hold on; semilogx([w(1) wcp wcp],[0 0 -200]); hold off;
text(wcp,0,['W = ' num2str(wcp)]);
%
sbplot(212);
semilogx(w,ph,'-',w,0*w-180,'-'); grid; frz_axis;
ylabel('PHASE (DEGREES)'); xlabel('FREQUENCY (RAD/SEC)');
hold on; semilogx([wcp wcp],[0 pm]-180); hold off;
text(wcp,pm-180,['P.M. = ' num2str(pm)]);
