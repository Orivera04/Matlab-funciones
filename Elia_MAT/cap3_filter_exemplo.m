% cap3_filter_exemplo ()
echo on
% Gerar sinal com frequencias 15 e 50 Mhz
t=0:0.01:pi;
s=sin(15*t)+sin(50*t);
[b,a]=ellip(4,10,20,0.5);
fs=filter(b,a,s);
plot(t,s,t,fs)
