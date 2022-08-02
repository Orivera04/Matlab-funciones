% Program name is ex511.m 
% To accompany the textbook:
% Applications of MATLAB: Numerical Solutions.
% By Yasin A. Shiboul
% To run this program, enter its name,'ex511' in the command window.
%
V=230;
f=50;
R=100;
L=310e-3;
C=31.8e-6;
S=input('What is the position of the switch')
% Finding the impedance of the circuit
switch S
case 1
   Z=R
case 2
   Z=j*2*pi*f*L
case 3
   Z=-j/(2*pi*f*C)
otherwise
   disp('Not valid switch position')
   break
end

% Finding the current in complex form
C=V/Z;
% Finding the RMS value of the current
I=abs(C);
% Finding the phase displacement of the current wave form
alpha=angle(C);
% Plotting the voltage and current waveform for one period
wt=0:0.01:2*pi;
Vin=sqrt(2)*V*sin(wt);
Iin=sqrt(2)*I*sin(wt+alpha);
subplot(2,1,1)
plot(wt,Vin)
subplot(2,1,2)
plot(wt,Iin)
