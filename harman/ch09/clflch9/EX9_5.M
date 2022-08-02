% EX9_5.M Compute the spectrum of a signal saved
%   in file CLEX95.MAT. (Created by CLEX95DT.M) The data are:
%   N   samples of the |FFT| are plotted
%   Ts   sampling interval in seconds
%   t   time points
%   ft  function f(t)
% Calls clfftf to compute DFT
load clex95.mat                    % Load N,Ts,t,ft
fs=1/(N*Ts);                       % Frequency spacing	
fhertz=fs*linspace(-N/2,N/2-1,N);  % Create frequency axis
[FT,FTmag,FTarg]=clfftf(ft,N,Ts);  % Compute DFT
% Plot f(t) and DFT 
subplot(2,1,1), plot(t,ft)         % Time function
title('Signal')
xlabel('Time in seconds'), ylabel('f(t)')
subplot(2,1,2),plot(fhertz, FTmag) % Spectrum
xlabel('Frequency in hertz')
ylabel('Spectrum')
%
% Modify the script to use other data files. The M-file
%  that created the data file is CLEX95DT.M

