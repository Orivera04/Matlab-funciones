% Script p5_4_09r.m; cart with a pendulum using TLQHR; s=[y v th q]';
%                                                        8/97, 7/14/02
%
ep=.5; A=[0 1 0 0; 0 0 ep 0; 0 0 0 1; 0 0 -1 0]; B=[0 1 0 -1]';
Q=zeros(4); N=zeros(4,1); R=1; tf=2*pi; x0=[0 0 0 0]'; Mf=eye(4);
Sf=zeros(4); R=1; psi=[1 0 0 0]'; t1=.8*tf; tol=1e-4;
[x,u,t,t1b,K]=tlqhr(A,B,Q,N,R,tf,x0,Sf,Mf,psi,t1,tol);
t=t/tf; t1b=t1b/tf; 
%
figure(1); clf; subplot(211), plot(t,x(:,1)); grid; ylabel('y');
subplot(212), plot(t,x(:,3),t,u); grid; xlabel('t/t_f')
legend('Force u','\theta')
%
figure(2); clf; plot(t1b,K); grid; xlabel('t/t_f')
ylabel('Fdbk Gains'); legend('K_y','K_v','K_\theta','K_q',2)
	

	