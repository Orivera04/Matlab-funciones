clc; disp('Dead_zn  :'); help dead_zn;
disp('Press any key to display the Dead Zone response curve');
disp('(Same as Figures 10.08)'); pause;
dm = linspace(0,1); n = dead_zn(dm);
clg; plot(dm,n); grid;
title('Dead Zone'); xlabel('D/M'); ylabel('| N/K1 |');
% meta demo52
pause; clear dm n;
clc; disp('To find LIMIT Cycles (used to determine stability):');
disp('  1. Overlay the transfer function plot and the Dead Zone plot (-1/N).');
disp('  2. Determine Intersections of these two plots.');
disp(' '); disp('Example of problem 10.18');
disp(' '); disp('For the transfer function :');
disp('num = 20; den = [conv([1 .05],[1 .1]) 0]; w = logspace(-2,1);');
num = 20; den = [conv([1 .05],[1 .1]) 0]; w = logspace(-2,1);
disp('[mag,ph] = bode(num,den,w); magdb = 20*log10(mag);');
[mag,ph] = bode(num,den,w); magdb = 20*log10(mag);
disp(' '); disp('For the Dead Zone curve :');
disp('dm = linspace(.9999,0); n = dead_zn(dm); ninv = (0*n-1)./n;');
dm = linspace(.9999,0); n = dead_zn(dm); ninv = (0*n-1)./n;
disp(' '); disp('Press any key to overlay the two curves (with a few points labeled)');
pause;
clg; plot([-270 -90],[-10 120],'.'); grid;
hold on; plot(ph,magdb,'-r',0*n-180,20*log10(abs(ninv)),'--g'); hold off;
xlabel('Phase (degrees)'); ylabel('Gain (dB)');
w = [.01 .03 .05 .2 .5 1 2 3.9]; [mag,ph] = bode(num,den,w); magdb = 20*log10(mag);
hold on; plot(ph,magdb,'*r'); hold off;
for ii = 1:length(w); text(ph(ii),magdb(ii),[' w = ' num2str(w(ii))]); end;
dm = [.9997 .997 .995 .99 .98 .95 .9 .8 .6 .1]; 
n = dead_zn(dm); ninv = (0*n-1)./n;
hold on; plot(0*n-180,20*log10(abs(ninv)),'*g'); hold off;
for ii = 1:length(dm);
  text(-180,20*log10(abs(ninv(ii))),[' D/M = ' num2str(dm(ii))]);
end;
% meta demo52
pause;

clc; disp('To find the intersection (LIMIT Cycles) of the two curves');
disp(' We know that there is one intersections, from the graph.');
nm = polysbst(num,[sqrt(-1),0]); dn = polysbst(den,[sqrt(-1),0]);
disp(' The occurs between D/M = ..9997 and D/M = .997');
disp(' '); disp('To find it we do :');
disp('dm = crosser(''dead_zn'',[.9997 .997],[],[],nm,dn)');
dm = crosser('dead_zn',[.9997 .997],[],[],nm,dn)
disp('n = dead_zn(dm); ninv = -1/n'); n = dead_zn(dm); ninv = -1/n
disp('Then we can find w by either the phase or magintude of -1/n.'); 
disp('From the dead zone curve, we know that the angle is -180,');
disp('so we''ll use polyangl with -180.');
disp('w = polyangl(nm,dn,-180)');
w = polyangl(nm,dn,-180)
disp('Press any key to display the plot'); pause;
hold on; plot(-180,20*log10(abs(ninv)),'*'); hold off;
text(-180,20*log10(abs(ninv)),[' D/M = ' num2str(dm) ', w = ' num2str(w(1))]);
% meta demo52
pause; clear dm n ninv num den nm dn mag ph magdb ii ninv w;
