clc; disp('Backlash characteristics and LIMIT Cycles are determined using Back_lsh'); 
help back_lsh;
disp('Example using Figures 10.15 & 10.16'); disp(' ');
disp('dm = linspace(.999,0); n = back_lsh(dm);'); disp(' ');
disp('Press any key to display the BackLash response curves');
pause;
dm = linspace(.999,0); n = back_lsh(dm);
clg; sbplot(211); plot(dm,abs(n)); grid;
title('BackLash Amplitude'); xlabel('D/M'); ylabel('|N(M)|');
sbplot(212); plot(dm,angle(n)*180/pi); grid;
title('BackLash Phase'); xlabel('D/M'); ylabel('|N(M)|');
% meta demo51
pause;
clc; disp('To find LIMIT Cycles (used to determine stability):');
disp('  1. Overlay the transfer function plot and the Backlash plot (-1/N).');
disp('  2. Determine Intersections of these two plots.');
disp(' '); disp('Example of figure 10.26');
disp(' '); disp('For the transfer function :');
disp('num = 1.5; den = [conv([1 1],[1 1]) 0]; w = logspace(-1,0);');
num = 1.5; den = [conv([1 1],[1 1]) 0]; w = logspace(-1,0);
disp('[mag,ph] = bode(num,den,w); magdb = 20*log10(mag);');
[mag,ph] = bode(num,den,w); magdb = 20*log10(mag);
disp(' '); disp('For the Backlash curve :');
disp('dm = linspace(.95,0); n = back_lsh(dm); ninv = (0*n-1)./n;');
dm = linspace(.95,0); n = back_lsh(dm); ninv = (0*n-1)./n;
disp(' '); disp('Press any key to overlay the two curves (with a few points labeled)');
pause;
ninvangl = unwrap(angle(ninv))*180/pi; % due to dm = 0
clg; plot(ph,magdb,'-r',ninvangl,20*log10(abs(ninv)),'--g',[-90 -185],[25 -5],'.'); grid;
xlabel('Phase (degrees)'); ylabel('Gain (dB)');
w = [.1 .45 .6 1]; [mag,ph] = bode(num,den,w); magdb = 20*log10(mag);
hold on; plot(ph,magdb,'*r'); hold off;
for ii = 1:length(w); text(ph(ii),magdb(ii),[' w = ' num2str(w(ii))]); end;
dm = [.9 .75 .6 .4 0]; n = back_lsh(dm); ninv = (0*n-1)./n;
ninvangl = unwrap(angle(ninv))*180/pi; % due to dm = 0
hold on; plot(ninvangl,20*log10(abs(ninv)),'*g'); hold off;
for ii = 1:length(dm);
  text(ninvangl(ii),20*log10(abs(ninv(ii))),[' D/M = ' num2str(dm(ii))]);
end;
% meta demo51
pause;
disp(' '); disp('To find the intersection (LIMIT Cycles) of the two curves');
disp(' We know that there are two intersections, from the graph.');
nm = polysbst(num,[sqrt(-1),0]); dn = polysbst(den,[sqrt(-1),0]);
disp(' The first occurs between D/M = .75 and D/M = .9');
disp(' The second occurs between D/M = 0 and D/M = .4');
disp(' '); disp('To find the first we do :');
disp('dm = crosser(''back_lsh'',[.75 .9],[],[],nm,dn)');
dm = crosser('back_lsh',[.75 .9],[],[],nm,dn)
disp('n = back_lsh(dm); ninv = -1/n'); n = back_lsh(dm), ninv = -1/n
disp('Then we find w by either the phase or magintude of -1/n. We''ll try polymag.');
disp('w = polymag(nm,dn,abs(ninv))');
w = polymag(nm,dn,abs(ninv))
disp(' '); disp('Similarly for the second intersection');
disp('Press any key to display the plot'); pause;
hold on; plot(angle(ninv)*180/pi,20*log10(abs(ninv)),'*'); hold off;
text(angle(ninv)*180/pi,20*log10(abs(ninv)),[' D/M = ' num2str(dm) ', w = ' num2str(w(1))]);
dm = crosser('back_lsh',[0 .4],[],[],nm,dn);
n = back_lsh(dm); ninv = -1/n;
w = polymag(nm,dn,abs(ninv));
hold on; plot(angle(ninv)*180/pi,20*log10(abs(ninv)),'*'); hold off;
text(angle(ninv)*180/pi,20*log10(abs(ninv)),[' D/M = ' num2str(dm) ', w = ' num2str(w(1))]);
% meta demo51
pause; clear dm n ninv num den nm dn mag ph magdb ii ninvangl w;
