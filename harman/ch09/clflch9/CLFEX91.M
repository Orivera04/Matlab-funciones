% CLFEX91.M Plot f(t) and F(f) for two pulses
%   for Example 9.1
clear
clf
tstart=-3.0
tfinal=3.0
deltat=.02
% First pulse
A1=1			% Amplitude
tp1s=-0.5		% Start of Pulse
tp1f=0.5		% End of Pulse
t1=tstart:deltat:tp1s; 	%N1 points
f1=zeros(size(t1));
t2=tp1s:deltat:tp1f;	%N2 points, overlap at tp1s
f2=A1* ones(size(t2));
t3=tp1f:deltat:tfinal;	%N3 points, overlap at tp1f
f3=zeros(size(t3));
t=[t1 t2 t3];
f=[f1 f2 f3];
t2=[t1 tp1s];
subplot(2,1,1),plot(t,f)
axis([-2 2 0 1.5])
hold on
% Second
A2=0.5			% Amplitude
tp2s=-1.0		% Start of Pulse
tp2f=1.0		% End of Pulse
t1=tstart:deltat:tp2s; 	% N21 points
f1=zeros(size(t1));
t2=tp2s:deltat:tp2f;	%N22 points, overlap at tp1s
f2=A2* ones(size(t2));
t3=tp2f:deltat:tfinal;	%N23 points, overlap at tp1f
f3=zeros(size(t3));
t=[t1 t2 t3];
f=[f1 f2 f3];
t2=[t1 tp1s];
subplot(2,1,1),plot(t,f,'--')
T1=tp1f-tp1s
T2=tp2f-tp2s
title('Two pulses and spectrum Figure 9.1')
xlabel('t seconds')
ylabel('Amplitude')
hold off
% Frequency
deltaf=.02
xf=[-2:deltaf:2];
xf=xf+(xf==0)*eps;	% Avoid divide by zero
Tau1=T1/2
F=(A1*T1)*sin(2*pi*xf.*Tau1)./(2*pi*xf.*Tau1);
subplot(2,1,2),plot(xf,F)
hold on
axis([-2 2 -.5 1.5])
Tau2=T2/2
F=(A2*T2)*sin(2*pi*xf.*Tau2)./(2*pi*xf.*Tau2);
subplot(2,1,2),plot(xf,F,'--')
grid
xlabel('f hertz')
ylabel('F(f)')
hold off
%
%  This script could be generalized and improved by adding comments
%
