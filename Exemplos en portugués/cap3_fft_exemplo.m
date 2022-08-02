% cap3_fft_exemplo ()
echo on
% Gerar sinal com frequencias 50 e 120 Mhz
t = 0:0.001:0.6;
x = sin(2*pi*50*t)+sin(2*pi*120*t);
ys = x + 2*randn(size(t));
subplot(1,2,1)
plot(1000*t(1:50),ys(1:50))
title('Sinal com ruido')
% Transformada de st
Y = fft(ys,512);
% Conjugado de Yst
Pyy = Y.* conj(Y) / 512;
subplot(1,2,2)
f = 1000*(0:256)/512;
plot(f,Pyy(1:257))
title('Frequencia')
