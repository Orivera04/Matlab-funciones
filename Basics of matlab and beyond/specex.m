Fs = 1000;
t = linspace(0,2*pi,8192);
x = sin(t);
y = vco(x,[0 500],Fs);
[z,freq,time] = specgram(y,[],Fs);
subplot(221)
 imagesc(time,freq,20*log10(abs(z)))
 axis xy
 colormap(flipud(gray))
 colorbar
 xlabel('Time, sec')
 ylabel('Frequency, Hz')

subplot(223)
 surfl(time,freq,20*log10(abs(z)))
 shading flat
 xlabel('Time, sec')
 ylabel('Frequency, Hz')
 zlabel('Power, dB')