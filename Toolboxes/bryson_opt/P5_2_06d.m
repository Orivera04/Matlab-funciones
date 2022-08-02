% Script p5_2_06d.m; undamped oscillator with soft terminal
% constraints using TLQS; s=[y v]';                7/97, 3/31/01
%
A=[0 1; -1 0]; B=[0 1]'; Q=zeros(2); N=[0 0]'; R=1; Ns=[50 100];
s0=[1 0]'; Qf=1e4; Mf=eye(2); psi=[0 0]'; tf=[2 10]*pi; 
for i=1:2, 
 [s,u,t]=tlqs(A,B,Q,N,R,tf(i),s0,Mf,Qf,psi,Ns(i));
 figure(i); clf; subplot(211), t=t/(2\pi);
 plot(t,s); grid; legend('y','v'); subplot(212),
 plot(t,u); grid; ylabel('u');  xlabel('t/(2\pi)');
end 

