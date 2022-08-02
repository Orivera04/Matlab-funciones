% Script e06_3_2.m; response of discrete-controlled undamped oscillator
% to x(0)=[-1 0]';                                        7/92, 6/24/02
%
a=pi/16; Phi=[cos(a) sin(a);-sin(a) cos(a)]; Gam=[1-cos(a);sin(a)]; 
C=[1 0]; k=dlqr(Phi,Gam,9*C'*C,1); xo=[-1 0]; w=zeros(33,1);
t=[0:1/32:1]'; [y,x]=dlsim(Phi-Gam*k,Gam,C,0,w,xo); u=-x*k';
%
figure(1); clf; subplot(211),plot(t,x); grid; axis([0 1 -1 1])
text(.25,.7,'x_2'); text(.25,-.3,'x_1'); subplot(212), zohplot(t,u);
grid; text(.35,.25,'u'); xlabel('\omega t/2\pi)')