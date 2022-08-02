% Script p5_4_11.m; tip deflec. of flexible robot arm w. shoulder torque
% using TLQH (flg=1) or TLQHR (flg=2); x=[th1 q1 th2 q2]'; u=T; y in l,
% time in 1/om, q in om, om=2.782*sqrt(k/ml^2), T in k;   12/96, 7/15/02 
%
flg=1; ep=.4251; psi=[0 0 0 0]'; R=1; Ns=40; tf=2*pi; A=[0 1 0 0; -ep ...
  0 ep 0; 0 0 0 1; 1-ep 0 -1+ep 0]; B=[0 .2003 0 -.2248]'; Q=zeros(4);
N=zeros(4,1); x0=[-.5 0 -.5 0]'; Mf=eye(4); Sf=zeros(4); psi=zeros(4,1);
if flg==1, [x,u,t]=tlqh(A,B,Q,N,R,tf,x0,Sf,Mf,psi,Ns); y=[1 0 1 0]*x;
elseif flg==2, t1=.8*tf; tol=1e-4;
 [x,u,t,t1k,K]=tlqhr(A,B,Q,N,R,tf,x0,Sf,Mf,psi,t1,tol); y=x*[1 0 1 0]';
end
%
figure(1); clf; ; t=t/tf; subplot(211),plot(t,y); grid; ylabel('y/l')
axis([0 1 -1.2 .2]); subplot(212); plot(t,x(1,:),t,x(3,:),t,u/5,'r--'); 
grid; axis([0 1 -2 2]); xlabel('\omega t/2\pi'); text(.12,1.1,'T/5')
text(.32,.9,'\theta_1'); text(.42,-1.3,'\theta_2')
