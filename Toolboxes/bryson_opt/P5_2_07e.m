% Script p5_2_07e.m; inverted pendulum with TLQS; s=[y v]'; 
%                                               7/97, 3/31/02
%
A=[0 1; 1 0]; B=[0 1]'; Q=zeros(2); N=[0 0]'; R=1; s0=[1 0]'; 
Qf=1e4; Mf=eye(2); psi=[0 0]'; tf=[6 28]; Ns=[50 100];
for i=1:2, 
 [s,u,t]=tlqs(A,B,Q,N,R,tf(i),s0,Mf,Qf,psi,Ns(i));
 figure(i); clf; subplot(211), plot(t,s); grid 
 legend('y','v');
 subplot(212), plot(t,u); grid; ylabel('u');  xlabel('t')
end 

