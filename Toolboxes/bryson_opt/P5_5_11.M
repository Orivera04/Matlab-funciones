% Script p5_5_11.m; tip deflection of flexible robot arm using TDLQH
% (flg=1) or TDLQHR (flg=2); s=[th1 q1 th2 q2]'; u=T; y in l, t in 1/om,
% q in om, om=2.782*sqrt*(k/ml^2), T in k;                 7/97, 7/25/02
%
flg=1; ep=.4251; psi=[0 0 0 0]'; R=1; Ns=40; tf=2*pi; A=[0 1 0 0; ...
      -ep 0 ep 0; 0 0 0 1; 1-ep 0 -1+ep 0]; B=[0 .2003 0 -.2248]'; 
Q=zeros(4); N=zeros(4,1); s0=[-.5 0 -.5 0]'; Mf=eye(4); Sf=zeros(4);
psi=zeros(4,1); Ts=tf/Ns; [Ph,Ga]=c2d(A,B,Ts); t=[0:1/Ns:1]; nf=5;
if flg==1, [s,u]=tdlqh(Ph,Ga,Q,N,R,s0,Sf,Mf,psi,Ts,Ns); 
elseif flg==2, [s,u]=tdlqhr(Ph,Ga,Q,N,R,s0,Sf,Mf,psi,Ts,Ns,nf);
end; y=[1 0 1 0]*s; uh=[u u(Ns)]; 
%
figure(1); clf; subplot(211),plot(t,y); grid; ylabel('y/l')
axis([0 1 -1.2 .2]); subplot(212); plot(t,s([1 3],:)); grid; hold on
zohplot(t,uh/5); hold off; axis([0 1 -2 2]); xlabel('\omega t/(2\pi)')
text(.12,1.1,'T/5'); text(.32,.9,'\theta_1'); text(.42,-1.3,'\theta_2')
