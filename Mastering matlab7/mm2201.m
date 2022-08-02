% mm2201.m

N = 128;  % choose a power of 2 for speed
t = linspace(0,3,N);  % time points for function evaluation
f = 2*exp(-3*t);  % evaluate the function and minimize aliasing: f(3) ~ 0
Ts = t(2) - t(1);  % the sampling period
Ws = 2*pi/Ts;  % the sampling frequency in rad/sec
F = fft(f); % compute the fft
Fc=fftshift(F)*Ts;
W=Ws*(-N/2:(N/2)-1)/N;


Fa = 2./(3+j*W); % evaluate analytical Fourier transform

plot(W,abs(Fa),W,abs(Fc),'.') % generate plot, 'o' mark fft results
xlabel('Frequency, Rad/s')
ylabel('|F(\omega)|')
title('Figure 22.1: Fourier Transform Approximation')