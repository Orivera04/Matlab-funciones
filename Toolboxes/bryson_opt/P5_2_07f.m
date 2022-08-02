% Script p5_2_07f.m; inv. pendulum using TLQSR; s=[y v]';
%                                              8/97, 3/31/02
%
A=[0 1; 1 0]; B=[0 1]'; Q=zeros(2); N=zeros(2,1); R=1;
tf=10*pi; x0=[-1 0]'; Mf=eye(2); Qf=1e4; psi=[0 0]';
tol=1e-5; [x,u,t,tk,K]=tlqsr(A,B,Q,N,R,tf,x0,Mf,Qf,psi,tol);
t=t/tf; tk=tk/tf; 
%
figure(1); clf; subplot(311), plot(t,x); grid
legend('y','v'); subplot(312), plot(t,u); grid
ylabel('u'); subplot(313), plot(tk,K); grid; 
axis([.98 1 0 300]); ylabel('Fdbk Gains'); xlabel('t/t_f');
	

