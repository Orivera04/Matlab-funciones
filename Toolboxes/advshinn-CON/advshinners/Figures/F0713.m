num = 320; den = [1 10 0]; w = logspace(0,2);
[mag ph] = bode(num,den,w); db = 20*log10(mag);
[gm pm wcg wcp] = margins(num,den); gm = 20*log10(gm);
%if ~ isempty(find(ph > -90)), ph = ph-360; end;
%
clf; hold off; sbplot(211);
semilogx(w,db,'-',w,0*w,'-'); grid; frz_axis;
title('BODE DIAGRAM OF UNCOMPENSATED SYSTEM');
ylabel('GAIN (DB)'); xlabel('FREQUENCY (RAD/SEC)');
hold on; semilogx([wcp wcp],[0 -900]); hold off;
text(wcp,0,['W = ' num2str(wcp)]);
%
sbplot(212);
semilogx(w,ph,'-',w,0*w-180,'-'); grid; frz_axis;
%title('BODE DIAGRAM OF UNCOMPENSATED SYSTEM');
ylabel('PHASE (DEGREES)'); xlabel('FREQUENCY (RAD/SEC)');
hold on; semilogx([wcp wcp],[pm 0]-180); hold off;
text(wcp,pm-180,[' Phase = ' num2str(pm-180)]);
text(wcp,-180,['W = ' num2str(wcp)]);
