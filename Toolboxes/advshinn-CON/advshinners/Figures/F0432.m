num = [-1/7.69 1]; den = [1 0 0]; v = logspace(-2,2);
[mag ph] = bode(num,den,v); db = 20*log10(mag);
[m7 p7] = bode(num,den,7); m7 = 20*log10(m7);
if ( ph(1) > 0 ), ph = ph-360; end;
[gm pm vcg vcp] = margins(num,den); gmdb = 20*log10(gm);
%
clf; hold off; sbplot(211);
semilogx(v,db,'-',v,0*v,'-'); grid; frz_axis;
ylabel('GAIN (DB)'); xlabel('FREQUENCY (RAD/SEC)');
hold on; semilogx([v(1) 7 7],[m7 m7 -900],'-'); hold off;
text(7,m7,['Gain (V=7) = ' num2str(m7)]);
hold on; semilogx([vcp vcp],[0 -900]); hold off;
text(vcp,0,['V = ' num2str(vcp)]);
%
sbplot(212);
semilogx(v,ph,'-',v,0*v-180,'-'); grid; frz_axis;
ylabel('PHASE (DEGREES)'); xlabel('FREQUENCY (RAD/SEC)');
hold on; semilogx([vcp vcp],[pm 0]-180); hold off;
text(vcp,pm-180,[' P.M. = ' num2str(pm)]);
