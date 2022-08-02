num = 11.7;
den = [conv([0.05 1],[0.1 1]) 0];
%
[wp,mp] = wpmp(num,den); mp = 20*log10(mp);
%
den = den+[0 0 0 num]; % closed loop unity gain
w = logspace(0,2,200);
[gain phase] = bode(num,den,w);
frz_axis([0 2 -20 10],1); semilogx(w,20*log10(gain)); grid; 
frz_axis([0 2 -20 10],1);
xlabel('FREQUENCY (RAD/SEC)'); ylabel('GAIN (db)');
hold on;
semilogx([w(1) wp wp],[mp mp -100],'-');
semilogx(wp,mp,'*b');
hold off;
text(w(1),mp,[' Mp = ' num2str(mp) 'db']);
text(wp,-20,[' Wp = ' num2str(wp)]);
