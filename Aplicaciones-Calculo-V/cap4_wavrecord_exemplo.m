echo on
% cap4_wavrecord_exemplo
% Frequencia
Fs = 11025; 
% Grava
y = wavrecord(5*Fs,Fs,'int16');
% Reproduz
pause
wavplay(y,Fs);