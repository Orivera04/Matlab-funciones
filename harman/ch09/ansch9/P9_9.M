% P9_9.M Compare the magnitude of FFT of two sine waves ( 20 Hertz vs. 19 Hertz)
% N  number of samples
%   If N samples of the |FFT| are plotted, there will be a symmetry
%        about the frequency point  (1/(NT))/2
% T  sampling interval in seconds
% k  index
% hertz index in Hertz
%
% Result has Resolution= 1/NT= 2Hz; Valid Range is to 64Hz, plotted to 128Hz
%   (There will be symmetry about 64Hz ie at 64+(64-20)=108Hz)
N=64;
T=1/128;
k=0:N-1;
% f is a two column array comparing 20Hz and 19Hz sine wave
f=[sin(2*pi*20*k*T); sin(2*pi*19*k*T)]';
magfft=abs(fft(f));
hertz=k*(1/(N*T));
% Plot and compare.
clf    % Clear any figure
subplot(211), plot(hertz,magfft(:,1))
title('Magnitude of FFT (Sine, 20 Hertz)')
xlabel('frequency Hz'), ylabel('|F(w)| Hertz')
subplot(212), plot(hertz,magfft(:,2))
title('Magnitude of FFT (Sine, 19 Hertz)')
xlabel('frequency Hz'), ylabel('|F(w)| Hertz')
%
% Version 5  use clf (not clg)



