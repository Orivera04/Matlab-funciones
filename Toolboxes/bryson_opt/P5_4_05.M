% Script p5_4_05.m; inverted pendulum using TLQH;  x=[th thdot]'; 
% FAILS for tf>18;                                   7/97, 7/4/02
%
A=[0 1; 1 0]; B=[0 1]'; Q=zeros(2); N=[0 0]'; R=1; x0=[1 0]';
Mf=eye(2); Sf=zeros(2); psi=[0 0]'; tf=[6 15]; Ns=[50 100];
for i=1:2, 
 [x,u,t]=tlqh(A,B,Q,N,R,tf(i),x0,Sf,Mf,psi,Ns(i));
 figure(i); clf; subplot(211), plot(t,x); grid
 legend('\theta','dot\theta'); subplot(212), plot(t,u);
 grid; xlabel('t'); ylabel('u'); xlabel('t')
end 

