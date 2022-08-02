% Script p5_4_10r.m; cart with inv. pendulum using TLQHR; s=[y v th q]';
%                                                          2/93, 7/14/02
%
ep=.5; A=[0 1 0 0; 0 0 -ep 0; 0 0 0 1; 0 0 1 0]; B=[0 1 0 -1]';
Q=zeros(4); N=zeros(4,1); R=1; Mf=eye(4); tf=15; x0=[0 0 0 0]'; 
Sf=zeros(4); psi=[1 0 0 0]'; t1=.95*tf; tol=1e-4;
[x,u,t]=tlqhr(A,B,Q,N,R,tf,x0,Sf,Mf,psi,t1,tol);
%
figure(1); clf; subplot(211), plot(t,x(:,1)); grid; ylabel('y/l')
axis([0 tf -.1 1.1]); subplot(212), plot(t,x(:,3),t,u); grid
xlabel('t'); legend('\theta','Force u')
	

