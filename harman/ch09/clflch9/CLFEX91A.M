% CLFEX91a.M Plot f(t) and F(f) for a triangle
%  for Example 9.1
clear
clf
tstart=-3.0
tfinal=3.0
deltat=.01
t=tstart:deltat:tfinal;
% Triangle
A=1			% Amplitude
tp1s=-1.0		% Start of Rise
tp1f=1.0		% End of Pulse
T1=tp1f-tp1s
t1=tstart:deltat:tp1s; 	%N1 points
f1=zeros(size(t1));
t2=tp1s:deltat:0;
f2=A*(1-abs(t2./tp1s));
%f2=t.*[t ,= ones(size(t2));
t3=0:deltat:tp1f;	%N3 points, overlap at tp1f
f3=A*(1-abs(t3./tp1f));
t4=tp1f:deltat:tfinal;
f4=zeros(size(t4));
t=[t1 t2 t3 t4];
f=[f1 f2 f3 f4];
subplot(2,1,1),plot(t,f)
axis([-2 2 0 1.5])
title('Triangular pulse and spectrum Figure 9.2')
xlabel('t seconds')
ylabel('Amplitude')
hold off
% Frequency
deltaf=.01
xf=[-2:deltaf:2];
xf=xf+(xf==0)*eps;	% Avoid divide by zero
Tau1=T1/4               % T1 is total pulse width
F=(A*T1/2)*(sin(2*pi*xf.*Tau1)./(2*pi*xf.*Tau1)).^(2);
subplot(2,1,2),plot(xf,F)
axis([-2 2 -.5 1.5])
grid
xlabel('f hertz')
ylabel('F(f)')

