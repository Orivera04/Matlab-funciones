% EX9_3.M  Compute and plot the DFT of f(t)=exp(-t)
%  Creates f(t) sampled each Ts seconds for T seconds
%  Input:  N   -number of points input
%          T   -Period of signal
%      t0 =0   -start of time points
%  Calls clfftf to compute DFT
N=input('Number of points N= ')	 % Sample N points
T=input('Period of signal T= ')
Ts=T/N;                          % Sampling interval 
% Form the vector of time points and f(n*Ts)
t0=0;                            % Start of signal 
ts=(t0:Ts:Ts*(N-1));             % Compute N points
ft=exp(-ts);
% Determine the spectrum 
[Fft,Ffmag,Ffang]=clfftf(ft,N,Ts);	 
% Compute the frequency values in hertz fs=1/(N*Ts); fmax=1/(2*Ts)
% 
fs=1/(N*Ts);                     % Frequency spacing
f=fs*linspace(-N/2,N/2-1,N);     % N points in frequency
% Plot Fexact and DFT result
w=2*pi*f;
Fexact=1./(sqrt(1+w.^2));        % Magnitude
Thetaex=-(180/pi)*atan(w);       % Angle in degrees
clf
subplot(2,1,1),plot(f,Fexact(1:N),'--',f,Ffmag(1:N));
title(['FT and DFT of exp(-t), N=',num2str(N), ' T= ',num2str(T),' sec'])
xlabel('Frequency in hertz')
ylabel('FT and DFT')
legend('FT','DFT')
subplot(2,1,2),plot(f,Thetaex(1:N),'--',f,Ffang(1:N));
xlabel('Frequency in hertz')
ylabel('Phase FT and DFT')
legend('FT','DFT')
%
% Try the zoom on command to observe the graphs better.
% 
