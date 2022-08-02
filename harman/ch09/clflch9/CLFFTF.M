function [FT,FTmag,FTang] = clfftf(ft,N,Ts)
% CALL: [FT,FTmag,FTang] = clfftf(ft,N,Ts) Compute the DFT 
%  approximation of the Fourier Transform  
% Inputs:
% ft	Sampled function of time f(nTs)	
% N	Number of sample points
% Ts	Sample interval in seconds
% Outputs:
% FT	Approximate Fourier transform using DFT
% FTmag	Magnitude of spectrum
% FTang	Phase in degrees
% Determine the two-sided spectrum
FT1=Ts*(fft(ft,N));            % Scale to approximate FT
FT=fftshift(FT1);              % Shift 0 to center	
%
% Compute the magnitude and phase for the frequency values 
%    in hertz fs=1/(N*Ts); fmax=1/(2*Ts)
% 
FTmag=abs(FT);                 % Magnitude
FTang=(180/pi)*angle(FT);      % Phase in degrees
