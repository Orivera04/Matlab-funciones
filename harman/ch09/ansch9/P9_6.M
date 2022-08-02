% MAT9_6.M  Compute the FFT of a pulse and compare to the Fourier transform
%
clear
ft=[1;0;0;0];            % 25% duty cycle
ft=kron(ft,ones(64,1));
%
%
fprintf('Sample interval, Number of points, and sample period')
Ts= 1            % Sample interval (1 s)
N = length(ft)   % Number of points (256)
T = N*Ts         % Period in seconds (256s)
%
%  Note: length of time signal is (N-1)*T seconds -but period
%        for FFT is N*T
%
% Compute the exact Fourier transform
%   The pulse is shifted from zero by (N/4 +1)/2 = 32.5 sec 
%    - ignore the shift since only the magnitudes will be compared 
%
% Frequency Domain parameters
%
%  The FFT and FFTSHIFT yields frequencies -(N/2)*fs, ..,0,...,(N/2-1)*fs
%
fs= 1/(N*Ts);                               % .0039 Hz
xf=[-(N/2)*fs:fs:(N/2-1)*fs];   % Plot symmetrical spectrum
xf=xf+(xf==0)*eps;	                    % Avoid divide by zero
A1=1;
fprintf('Pulse width')
T1=T/4					    % Pulse width	
Tau1=T1/2;
F=(A1*T1)*sin(2*pi*xf.*Tau1)./(2*pi*xf.*Tau1);
FTmag = abs(F);
subplot(3,1,1); plot(xf,FTmag)
title('Fourier transform magnitude for pulse')
%
% Compute the DFT using the FFT
%
FT1=Ts*(fft(ft,N));         % Scale to approximate FT
FT=fftshift(FT1)';          % Shift 0 to center and create row 
%                              vector to compare manually	
%
% Create frequency axis - Values are the same as xf
%
FFTmag=abs(FT);                 % Magnitude
subplot(3,1,2); plot(xf,FFTmag)
title('DFT approximation')
%
% Compare the values FTmag with FFTmag
%  Experimenting showed that the error varies wildly due to
%   roundoff errors. Limit errors to 5 places. 
Ferror=((fix(10000*(FTmag -FFTmag))/10000)./(FTmag+eps))*100;  % Error in %
subplot(3,1,3); plot(xf,Ferror)
title('Error in percent')
% Other approaches:
% ginput  - use to pick off exact values from graphs
% zoom    - use to study the graphs more closely
%  It is possible to use  disp([FTmag;FFTmag]') to compare
%    numerical values point by point
