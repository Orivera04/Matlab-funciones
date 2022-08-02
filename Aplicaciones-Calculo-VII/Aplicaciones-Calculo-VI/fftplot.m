%FFTPLOT(in)
%   This function plots the power spectrum on the input vector.
%   The coding was altered slightly from the demo that comes with
%   Matlab, but here it is in one easy-to-use file.

function out = fftplot(in)

a = fft(in);
a(1) = [];
b = length(a)/2;
power = abs(a(1:b)).^2;
nyq = 1/2;
freq = (1:b)/b*nyq;
plot(freq,power);

out = 'Done';