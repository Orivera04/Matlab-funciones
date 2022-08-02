clc; disp('Bode Diagram :'); disp(' ');
disp('Example is Problem 6.58c (p0658c in problems subdirectory)');
disp(' G(s)H(s) = ((s+4)*(s+40))/(s^3(s+200)(s+900)) '); disp(' ');
disp('or (in MATLAB notation)'); disp(' ');
disp('num = conv([1 4],[1 40]);'); num = conv([1 4],[1 40])
disp('den = [conv([1 200],[1 900]) 0 0 0];');
den = [conv([1 200],[1 900]) 0 0 0]
disp(' '); disp('Press any key to display the Bode plot.'); pause;
% disp('Bld_bode : Not yet done!');
w = logspace(-2,4);
[mag,ph] = bode(num,den,w); 
magdb = 20*log10(mag); if (ph(1) > 0); ph = ph-360; end;
clg; sbplot(211); semilogx(w,magdb,w,0*w,'--g'); grid;
ylabel('Gain (db)'); xlabel('Frequency (rad/sec)');
sbplot(212); semilogx(w,ph,w,0*w-180,'--g'); grid;
ylabel('Phase (degrees)'); xlabel('Frequency (rad/sec)');
pause;

clc; disp('The Phase & Gain margins are found using MARGINS.');
help margins;
disp('This tansfer function has 2 gain margin values!');
disp('The MARGINS routine returns both values.'); disp(' ');
disp('[gm,pm,wcg,wcp] = margins(num,den), gmdb = 20*log10(gm)');
disp(' '); disp('Press any key to see the results.'); pause;
[gm,pm,wcg,wcp] = margins(num,den); gmdb = 20*log10(gm);
disp(' '); disp('gm ='); format short e; disp(gm); format;
disp('pm ='); disp(pm);
disp('wcg ='); disp(wcg);
disp('wcp ='); disp(wcp);
disp('gmdb ='); disp(gmdb);
disp('Press any key to display the Bode plot.'); pause;
% meta demo2
clg; sbplot(211);
semilogx(w,magdb,w,0*w,'--g',wcp,0*wcp,'*',[1;1]*wcg',[0;-1]*gmdb','--g');
grid; ylabel('Gain (db)'); xlabel('Frequency (rad/sec)');
for ii = 1:length(wcp)
  text(wcp(ii),0,[' Wcp = ' num2str(wcp(ii))]);
end;
for ii = 1:length(wcg);
  text(wcg(ii),-gmdb(ii),[' Gm = ' num2str(gmdb(ii))]);
end;
sbplot(212);
semilogx(w,ph,w,0*w-180,'--g',wcg,0*wcg-180,'*',[1;1]*wcp',[0;1]*pm'-180,'--g');
grid; ylabel('Phase (degrees)'); xlabel('Frequency (rad/sec)');
for ii= 1:length(wcp)
  % hold on; semilogx(wcp(ii)*[1 1],[0 pm(ii)]-180,'--g'); hold off;
  text(wcp(ii),-180+pm(ii),[' Pm = ' num2str(pm(ii))]);
end;
for ii = 1:length(wcg)
  % hold on; semilogx(wcg(ii),-180,'*'); hold off;
  text(wcg(ii),-180,[' Wcg = ' num2str(wcg(ii))]);
end;
pause; clear num den w mag ph magdb gm pm wcg wcp gmdb ii;

clc; disp('Transfer functions with a Time Delay:'); disp(' ');
disp('Example is Figure 6.33 (f0633 in figures subdirectory)');
disp(' G(jw) = (20*(1+0.2jw)/(jw(1+0.5jw)))*e^(-0.1jw) ');
disp(' '); disp('Press any key to display the Bode plot.'); pause;
num = 20*[.2 1]; den = [.5 1 0]; w = logspace(-1,2);
[mag,ph] = bode(num,den,w);
magdb = 20*log10(mag); ph = ph-.1*w'*180/pi;
[gm,pm,wcg,wcp] = margins(num,den); pm = pm-.1*wcp*180/pi;
wcg = crosses(w,crossing(ph,-180));
[mag2,ph2] = bode(num,den,wcg); gmdb = -20*log10(mag2);
% meta demo2
clg; sbplot(211); semilogx(w,magdb,w,0*w,'--g'); grid;
ylabel('Gain (db)'); xlabel('Frequency (rad/sec)');
hold on; semilogx(wcp,0,'*g'); hold off;
text(wcp,0,[' Wcp = ' num2str(wcp)]);
hold on; semilogx(wcg*[1 1],[0 -gmdb],'--g'); hold off;
text(wcg,-gmdb,[' Gm = ' num2str(gmdb)]);
sbplot(212); semilogx([1e-1 1e+2],[-200 0],'.'); grid;
ylabel('Phase (degrees)'); xlabel('Frequency (rad/sec)');
hold on; semilogx(w,ph,w,0*w-180,'--g'); hold off;
hold on; semilogx(wcp*[1 1],[0 pm]-180,'--g'); hold off;
text(wcp,pm-180,[' Pm = ' num2str(pm)]);
hold on; semilogx(wcg,-180,'*g'); hold off;
text(wcg,-180,[' Wcg = ' num2str(wcg)]);
pause; clear num den w mag ph magdb gm pm wcg wcp gmdb mag2 ph2;
% meta demo2
sbplot(111); clg;
