% EX8_14.M Plot frequency response of a system with pulse input
%  y'' +3 y' +2 y=P(t);  Pulse width is tau = 1 second.
w=[-4*pi:.1:4*pi];              % Frequency range
w=w + eps;                      % Avoid a divide by zero
Y=zeros(size(w));
P=zeros(size(w));
H=zeros(size(w));
%
A=1;                            % Pulse amplitude
tau =1;                         % Pulse width in seconds
alp=w*tau/2;
P=(A*tau)*abs((sin(alp))./alp);	% Transform of pulse
H=1./(sqrt(w.^4+w.^2+4));       % Transform of system
Y=P.*H;                         % Transform of output
% 
clf
subplot(2,1,1),plot(w,P,'-',w,H,'--')
axis([-15 15 0 1.1])
title('Spectrum of a pulse and the system - Figure 8.12')
xlabel('Frequency in radians/sec')
ylabel('F(w) and H(w)')
legend('Pulse','System')
subplot(2,1,2), plot(w,Y);
axis([-15 15 0 1])
xlabel('Frequency in radians/sec')
ylabel('Output Y(w)')
