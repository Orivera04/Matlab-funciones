% P9_7.M Computer DFT of sin(pi*t/4)  [0,4]
%  frequency is 1/8 Hertz; 4 seconds is half a cycle
clear
clf
N1=16;			% 16 Points
Ts=1			% Period 16 seconds
t1=0:1:4;		% Fmax is .5 Hz
N11=N1-length(t1);
f1=[sin(pi*t1./4) zeros(1,N11)];
FT1=fft(f1,N1);
fs=1/(N1*Ts);				% Frequency spacing
freq1=fs*linspace(0,N1-1,N1);    % N  points in frequency
subplot(2,1,1),plot(freq1,abs(FT1))			% Not shifted
title('N=16')
%
N2=64			% Period is 64 sec.
t1=0:1:4;
N21=N2-length(t1);
f2=[sin(pi*t1./4) zeros(1,N21)];
FT2=fft(f2,N2);
fs=1/(N2*Ts);			% Frequency spacing
freq2=fs*linspace(0,N2-1,N2);   % N  points in frequency
subplot(2,1,2),plot(freq2,abs(FT2),'--')
title('N=64, Ts=.5')
hold on
%
N3=128
Ts=.5			% Fmax is 1 Hz
t1=0:Ts:4;
N31=N3-length(t1);
f3=[sin(pi*t1./4) zeros(1,N31)];
FT3=fft(f1,N3);
fs=1/(N3*Ts);				% Frequency spacing
freq3=fs*linspace(0,N3-1,N3);    % N  points in frequency
subplot(2,1,2),plot(freq3,abs(FT3))
title('N=128')
