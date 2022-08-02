num = 5.14*conv([1 1],[-1/7.69 1]); den = [.01 1 0 0];
v = logspace(-1,3);
[mag ph] = bode(num,den,v); db = 20*log10(mag);
[gm,pm,vcg,vcp] = margins(num,den); gmdb = 20*log10(gm);
%
clf; hold off; sbplot(211);
semilogx(v,db); grid; frz_axis;
ylabel('GAIN (DB)'); xlabel('FREQUENCY (RAD/SEC)');
hold on; semilogx([v(1) vcp vcp],[0 0 -200]); hold off;
text(vcp,0,['V = ' num2str(vcp)]);
hold on; semilogx([vcg vcg],[-gmdb 0]); hold off;
text(vcg,-gmdb,[' G.M. = ' num2str(gmdb)]);
%
sbplot(212);
semilogx(v,ph); grid; frz_axis;
ylabel('PHASE (DEGREES)'); xlabel('FREQUENCY (RAD/SEC)');
hold on; semilogx([v(1) vcg vcg],[-180 -180 -5000]); hold off;
text(vcg,-180,['V = ' num2str(vcg)]);
hold on; semilogx([vcp vcp],[0 pm]-180); hold off;
text(vcp,pm-180,['P.M. = ' num2str(pm)]);
