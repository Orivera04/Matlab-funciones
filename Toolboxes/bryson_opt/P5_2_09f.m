% Script p5_2_09f.m; cart with a pendulum using TLQSR;
% s=[y v th q]';                          8/97, 3/31/02
%
ep=.5; A=[0 1 0 0; 0 0 ep 0; 0 0 0 1; 0 0 -1 0];
B=[0 1 0 -1]'; Q=zeros(4); N=zeros(4,1); R=1; tf=10*pi;
x0=[0 0 0 0]'; Mf=eye(4); Qf=3e4; R=1; psi=[1 0 0 0]';
tol=1e-5;
[x,u,t,tk,K]=tlqsr(A,B,Q,N,R,tf,x0,Mf,Qf,psi,tol);
t=t/tf; tk=tk/tf; 
%
figure(1); clf; subplot(311), plot(t,x(:,1)); grid 
subplot(312), plot(t,x(:,3),t,u); grid
axis([0 1 -.02 .02]); legend('Force u','\theta')
subplot(313), plot(tk,K); grid; xlabel('Time') 
ylabel('Fdbk Gains'); axis([.95 1 -300 300])
	

	