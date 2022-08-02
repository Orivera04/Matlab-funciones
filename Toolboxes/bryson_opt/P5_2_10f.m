% Script p5_2_10f.m; cart with an inverted pendulum using Riccati
% solution; s=[y v th q]';                          7/97, 3/31/02
%
ep=.5; A=[0 1 0 0; 0 0 -ep 0; 0 0 0 1; 0 0 1 0]; B=[0 1 0 -1]'; 
Q=zeros(4); N=zeros(4,1); R=1; tf=30; x0=[0 0 0 0]'; Mf=eye(4);
Qf=3e4; tol=1e-4; psi=[1 0 0 0]';
[x,u,t,tk,K]=tlqsr(A,B,Q,N,R,tf,x0,Mf,Qf,psi,tol); 
%
figure(1); clf; plot(tk,K); grid; xlabel('Time')
ylabel('Fdbk Gains'); axis([0 tf -300 300])
%
figure(2); clf; subplot(211), plot(t,x(:,1)); grid 
ylabel('Position y'); subplot(212), plot(t,x(:,3),t,u); grid 
axis([0 tf -.02 .02]); xlabel('Time'); ylabel('Force u & \theta')

	