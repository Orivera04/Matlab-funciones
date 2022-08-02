% Script f05_27.m; lateral intercept and rendezvous using
% TDLQS;                                      7/97, 4/4/02
%
tf=1; N=40; Ts=tf/N; Phi=[1 Ts; 0 1]; Gam=[Ts^2/2 Ts]';
Qd=zeros(2); Nd=zeros(2,1); Rd=1; x0=[0 1]'; Qf=3e5; 
% Intercept
Mf=[1 0]; psi=0;   
[x,u]=tdlqs(Phi,Gam,Qd,Nd,Rd,x0,Mf,Qf,psi,Ts,N); 
uh=[u u(N)]; t=tf*[0:1/N:1];
%
figure(1); clf; subplot(211), plot(t,x(1,:)); grid
axis([0 1 0 .2]); text(.5,.11,'y/(v_ot_f)');
subplot(212); plot(t,x(2,:)); grid; hold on
zohplot(t,uh/3); hold off; axis([0 1 -1 1]) 
xlabel('t/t_f'); text(.25,.52,'v/v_o') 
text(.71,.12,'at_f/(3v_o)') 
%
% Rendezvous
Mf=eye(2); psi=[0 0]';                           
[x,u]=tdlqs(Phi,Gam,Qd,Nd,Rd,x0,Mf,Qf,psi,Ts,N);
uh=[u u(N)];
%
figure(2); clf; subplot(211), plot(t,x(1,:)); grid
axis([0 1 0 .15]); text(.46,.06,'y/(v_ot_f)') 
subplot(212),plot(t,x(2,:)); hold on
zohplot(t,uh/4); hold off; axis([0 1 -1 1])
axis([0 1 -1 1]); grid; xlabel('t/t_f'); 
text(.28,.52,'v/v_o'); text(.68,.52,'at_f/(4v_o)'); 
%print -deps2 \book_do\figures\f05_27
