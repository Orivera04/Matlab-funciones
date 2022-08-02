% Script e05_4_2.m; lateral intercept using TLQHR; t in tf, v in vo,
% y in vo*tf, a in vo/tf;                              8/97, 7/14/02
%
A=[0 1; 0 0]; B=[0 1]'; Q=zeros(2); N=zeros(2,1); R=1; tf=1;
s0=[0 1]'; Sf=zeros(2); Mf=[1 0]; psi=0; t1=.85; tol=1e-5; 
[s,a,t,t1b,K]=tlqhr(A,B,Q,N,R,tf,s0,Sf,Mf,psi,t1,tol);
%
figure(1); clf; subplot(211), plot(t1b,K(:,1)); grid; ylabel('K_y')
axis([0 1 0 800]); subplot(212), plot(t1b,K(:,2)); grid
axis([0 1 0 40]); ylabel('K_v'); xlabel('t/t_f')
%
figure(2); clf; subplot(211), plot(t,s(:,1)); grid; axis([0 1 0 .2])
text(.5,.11,'y/v_0t_f'); subplot(212); plot(t,s(:,2),t,a/3); grid
axis([0 1 -1 1]); xlabel('t/t_f'); text(.25,.52,'v/v_0')
text(.71,.12,'at_f/3v_0') 
	