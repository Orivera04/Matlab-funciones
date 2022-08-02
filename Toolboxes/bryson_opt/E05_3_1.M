% Script e05_3_1.m; lateral intercept and rendezvous using TDLQS;
%                                                        7/97, 6/18/02
%
tf=1; N=40; Ts=tf/N; Phi=[1 Ts; 0 1]; Gam=[Ts^2/2 Ts]'; Qd=zeros(2); 
Nd=zeros(2,1); Rd=1; x0=[0 1]'; Qf=3e5;  
% Intercept
Mf=[1 0]; psi=0; 
[x,u]=tdlqs(Phi,Gam,Qd,Nd,Rd,x0,Mf,Qf,psi,Ts,N); uh=[u u(N)];
t=tf*[0:1/N:1];
%
figure(1); clf; subplot(211), plot(t,x(1,:)); grid; axis([0 1 0 .2])
ylabel('y/(v_ot_f)'); subplot(212); plot(t,x(2,:)); grid; hold on
zohplot(t,uh/3,'r'); hold off; axis([0 1 -1 1]); xlabel('t/t_f') 
legend('v/v_o','at_f/3v_o') 
%
% Rendezvous
Mf=eye(2); psi=[0 0]';                           
[x,u]=tdlqs(Phi,Gam,Qd,Nd,Rd,x0,Mf,Qf,psi,Ts,N); uh=[u u(N)];
figure(2); clf; subplot(211), plot(t,x(1,:)); grid; axis([0 1 0 .15])
ylabel('y/(v_ot_f)'); subplot(212),plot(t,x(2,:)); hold on
zohplot(t,uh/4,'r'); hold off; axis([0 1 -1 1]); axis([0 1 -1 1]);
grid; xlabel('t/t_f'); legend('v/v_o','at_f/4v_o',4) 
