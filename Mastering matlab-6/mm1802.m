%(MM1802.m plot)
Hz=[20:10:100 200:100:1000 1500 2000:1000:10000]; % frequencies in Hertz
spl=[76 66 59 54 49 46 43 40 38 22 ... % sound pressure level in dB
 14 9 6 3.5 2.5 1.4 0.7 0 -1 -3 ...
 -8 -7 -2 2 7 9 11 12];
semilogx(Hz,spl,'-o')
xlabel('Frequency, Hz')
ylabel('Relative Sound Pressure Level, dB')
title('Figure 18.2: Threshold of Human Hearing')
grid on
