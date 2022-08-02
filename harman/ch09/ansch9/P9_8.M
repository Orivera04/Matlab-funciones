% P9_8.M  Compare the FFT for various values of N
%
% Separate two signals at .3 Hz and .32 Hz using
%  ginput to select peaks  
T=1		% T=1 sec
k=0:T:(512-1)*T;			% Sampling at T=1 second 
%    fmin= 1/NT   fmax=N*(1/NT)/2 = 1/2T
ft=sin(0.6*pi*k) + 0.5*sin(0.64*pi*k);  % The function sampled every second.
N=64
Fw1=abs(fft(ft,N));	% Take N=64; Result is column vector
% Plot with pause between	
faxis=(0:N-1)/(N*T);
plot(faxis,Fw1)		% Convert to frequency scale
title('|F(w)| for 64 points')
pause
%
N=128
Fw2=abs(fft(ft,N));		% Take N=64; Result is column vector
faxis=(0:N-1)/(N*T);		% Convert to frequency scale
plot(faxis,Fw2)
title('|F(w)| for 128 points')
pause
%
N=256
Fw3=abs(fft(ft,N));		% Take N=64; Result is column vector
faxis=(0:N-1)/(N*T);		% Convert to frequency scale
plot(faxis,Fw3)
title('|F(w)| for 256 points')
pause
%
N=512
Fw4=abs(fft(ft,N));		% Take N=64; Result is column vector
faxis=(0:N-1)/(N*T);		% Convert to frequency scale
plot(faxis,Fw4)
title('|F(w)| for 512 points')
pause
% Plot half range and find frequencies (Move mouse to peak}
N=512/2
faxis2=faxis(1:256);
Fw42=Fw4(1:256);
fprintf(' On next plot, pick off the peaks\n')
pause
plot(faxis2,Fw42)
title('|F(w)| 512 points over range [0,.5] Hz-Pick the peaks')
fprintf('Frequency in Hertz and |F(w)|\n')
[x,y]=ginput;	% Pick points
[x,y]
%
% Add initial comments to explain the use of ginput.
%