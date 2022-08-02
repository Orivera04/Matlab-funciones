% Script p5_4_06.m; undamped oscillator using TLQH; s=[y v]';
%                                                 2/93, 7/4/02
%
A=[0 1; -1 0]; B=[0 1]'; Q=zeros(2); N=[0 0]'; R=1; x0=[1 0]';
Mf=eye(2); Sf=zeros(2); psi=[0 0]'; tf=[1 10]*pi; Ns=[50 100];
for i=1:2,
 [x,u,t]=tlqh(A,B,Q,N,R,tf(i),x0,Sf,Mf,psi,Ns(i));
 figure(i); clf; subplot(211), t=t/(2*pi); plot(t,x); grid 
 legend('y','v'); subplot(212), plot(t,u); grid; ylabel('a')
 xlabel('t/2\pi')
end

