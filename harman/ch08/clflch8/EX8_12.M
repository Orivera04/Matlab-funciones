% EX8_12.M Plot the Fourier transform (w>0) of a pulse for various 
%  widths.  Pulse width is tau = 16 and 4 seconds.
f=[0:.005:.75];         % Frequency
f=f + eps;              % Avoid a divide by zero
F1=zeros(size(f));
F2=zeros(size(f));
F3=zeros(size(f));
%
tau=16                  % Pulse width in seconds
F1=(1/pi)*(sin(pi*f*tau))./f;
tau=tau/4;              % Pulse width = 4 seconds
F2=(1/pi)*(sin(pi*f*tau))./f;
% 
clf                     % Clear any figures
plot(f,F1,'-',f,F2,'--')
title('One-sided spectrum of a pulse - Figure 8.10')
xlabel('Frequency in Hertz')
ylabel('F(w)')
grid
legend('Tau=16','Tau=4')
%
% Modify the script to allow an arbitrary pulse width to be input.
%  Scale the pulses to have the same dc value and compare the
%  spectra. 
