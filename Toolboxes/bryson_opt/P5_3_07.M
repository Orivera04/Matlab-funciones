% Script p5_3_07.m; control tip deflection of flexible robot arm 
% using TDLQS; x=[th1,q1,th2,q2]'; u=T; y in l, time in 1/om, q 
% in om, om=2.782*sqrt(k/ml^2), T in k, ;          2/93, 6/30/02
%
ep=.4251; x0=[0 0 0 0]'; tf=2*pi; N=40; Ts=tf/N; A=[0 1 0 0; ...
   -ep 0 ep 0; 0 0 0 1; 1-ep 0 -1+ep 0]; B=[0 .2003 0 -.2248]';
[Ph,Ga]=c2d(A,B,Ts); Qd=zeros(4); Nd=zeros(4,1); Rd=1; Qf=1e7;
Mf=eye(4); psi=[.5 0 .5 0]'; 
[x,u]=tdlqs(Ph,Ga,Qd,Nd,Rd,x0,Mf,Qf,psi,Ts,N); t=[0:1/N:1];
uh=[u u(N)]; y=[1 0 1 0]*x;
%
figure(1); clf; subplot(211),plot(t,y); grid; ylabel('y/l')
axis([0 1 -.2 1.2]); subplot(212); plot(t,x(1,:),t,x(3,:)); 
grid; hold on; zohplot(t,uh/5); hold off; axis([0 1 -2 2])
xlabel('om*t/(2*pi)'); text(.12,1.1,'T/5'); text(.32,.7,'th1') 
text(.42,-1.3,'th2')
