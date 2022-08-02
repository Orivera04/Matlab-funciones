% © Berta Miklos 1998; program a Jelfeldolgozas c. reszhez

t = (0:.01:10.23)';      % Az idovektor definicioja
x = sin(2*pi*10*t) + sin(2*pi*20*t); % A harmonikus osszetevok
y = x + 2*randn(size(t));% A normalis eloszlasu zaj
x=[];t=[];               % A helyfoglalas felszabaditasa
clc                      
plot(y(1:150)), 
title('Noisy time domain signal'),pause  % Az idojel
                                         % egy darabja
grid on;
print yt.eps -deps
clc
Y = fft(y,1024);         % A jel Fourier-transzformaltja
Pyy = Y.*conj(Y)/1024;   % A teljesitmenysuruseg spektrum
Y=[];y=[];               % Helyfoglalas felszabaditasa
clc
f = 100/1024*(0:511);    % A frekvenciaskala beallitasa
plot(f,Pyy(1:512)), 
title('Power spectral density'), ... % Az APSD 
xlabel('Frequency (Hz)'), pause      % kirajzolasa
grid on;
print apsd.eps -deps
clc
echo off
disp('End')