num = 440; den = [.025 1 0]; w = logspace(0,3);
[mag1 ph1] = bode(num,den,w); db1 = 20*log10(mag1);
[gm1,pm1,wcg1,wcp1] = margins(num,den); gm1db = 20*log10(gm1);
num = conv(num,conv([.033 1],[.025 1]));
den = conv(den,conv([.33 1],[.0025 1]));
[mag2 ph2] = bode(num,den,w); db2 = 20*log10(mag2);
[gm2,pm2,wcg2,wcp2] = margins(num,den); gm2db = 20*log10(gm2);
%
clf; hold off; sbplot(211);
semilogx(w,db1,'-',w,db2,'--'); grid; frz_axis;
ylabel('GAIN (DB)'); xlabel('FREQUENCY (RAD/SEC)'); hold on;
semilogx([w(1) wcp1 wcp1],[0 0 -200],'r-',[1.7 3.5],[-15 -15],'r-');
text(wcp1,0,['W = ' num2str(wcp1)]); text(4.1,-15,'Uncompensated');
semilogx([w(1) wcp2 wcp2],[0 0 -200],'g--',[1.7 3.5],[-25 -25],'g--');
text(wcp2,0,['W = ' num2str(wcp2)]); text(4.1,-25,'Compenstated');
hold off;
%
sbplot(212);
semilogx(w,ph1,'-',w,ph2,'--',w,0*w-180,'-'); grid; frz_axis;
ylabel('PHASE (DEGREES)'); xlabel('FREQUENCY (RAD/SEC)'); hold on; 
semilogx([wcp1 wcp1],[0 pm1]-180,'r-',[1.7 3.5],[-155 -155],'r-');
text(wcp1,pm1-180,['P.M. = ' num2str(pm1)]); text(4.1,-155,'Uncompensated');
semilogx([wcp2 wcp2],[0 pm2]-180,'g--',[1.7 3.5],[-165 -165],'g--');
text(wcp2,pm2-180,['P.M. = ' num2str(pm2)]); text(4.1,-165,'Compenstated');
hold off;
