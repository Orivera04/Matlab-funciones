% Script f05_28.m; Lateral Intercept and Rendezvous using 
% TDLQSR;		 		                     7/97, 4/4/02
%
tf=1; N=40; Ts=tf/N; Ad=[1 Ts; 0 1]; Bd=[Ts^2/2 Ts]';
Qd=zeros(2); Nd=zeros(2,1); Rd=1; x0=[0 1]'; Qf=3e5;
% Intercept
Mf=[1 0];  psi=0;			         
[x,u,K]=tdlqsr(Ad,Bd,Qd,Nd,Rd,x0,Mf,Qf,psi,Ts,N);
t=[0:1/N:1]; uh=[u u(N)]; tu=t(1:N); K1=squeeze(K);
%
figure(1); clf; subplot(211), plot(t,x(1,:)); grid
axis([0 1 0 .2]); text(.5,.11,'y/(v_ot_f)')
subplot(212); plot(t,x(2,:)); grid; hold on
zohplot(t,uh/3,'-'); hold off; axis([0 1 -1 1])
xlabel('t/t_f'); text(.25,.52,'v/v_o')
text(.71,.12,'at_f/(3v_o)')
%
figure(2); clf; subplot(211), zohplot(tu,K1(1,:));
grid; ylabel('K_y'); subplot(212), zohplot(tu,K1(2,:));
grid; xlabel('Time'); ylabel('K_v')
%
% Rendezvous
[x,u,K]=tdlqsr(Ad,Bd,Qd,Nd,Rd,x0,Mf,Qf,psi,Ts,N);
uh=[u u(N)]; K1=squeeze(K); 
figure(3); clf; subplot(211), plot(t,x(1,:)); grid
axis tight; text(.46,.06,'y/(v_ot_f)')
subplot(212),plot(t,x(2,:)); grid; hold on
zohplot(t,uh/4,'-'); hold off; axis([0 1 -1 1])
xlabel('t/t_f'); text(.28,.52,'v/v_o')
text(.68,.52,'at_f/(4v_o)') 
%
figure(4); clf; subplot(211), zohplot(tu,K1(1,:));
grid; ylabel('K_y'); subplot(212), zohplot(tu,K1(2,:));
grid; xlabel('Time'); ylabel('K_v')
%print -deps2 \book_do\figures\f05_28

	
