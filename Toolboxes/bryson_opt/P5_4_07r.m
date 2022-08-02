% Script p5_4_07r.m; inverted pendulum using TLQH;  x=[th thdot]'; 
% does NOT FAIL for tf > 18;                          7/97, 7/4/02
%
A=[0 1; 1 0]; B=[0 1]'; Q=zeros(2); N=[0 0]'; R=1; x0=[1 0]';
Mf=eye(2); Sf=zeros(2); psi=[0 0]'; tf=[6 15 20]; tol=1e-4;
for i=1:3, 
 [x,u,t]=tlqhr(A,B,Q,N,R,tf(i),x0,Sf,Mf,psi,.99*tf(i),tol);
 figure(i); clf; subplot(211), plot(t,x); grid;
 legend('\theta','\theta dot'); subplot(212), plot(t,u); grid
 ylabel('u'); xlabel('t')
end 

