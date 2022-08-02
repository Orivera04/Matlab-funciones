% Script f05_20.m; dumping roll/yaw angular momentum; oblate
% S/C w. symmetry axis cross-track; I=Ix=Iz=2*Iy/3 ==> a=b=.5;
% sg=50/pi; ep=.02; s=[phi p Hx psi r Hz]'; u=[ex ez]'; time  
% in units of 1/n, (p r Hx/Ix Hz/Iz sg) in n, u in R*I*n^2/N;
% 						                           7/91, 4/4/02
tf=pi/2; Ns=100; a=.5; b=.5; sg=50/pi; ep=.02; psi=zeros(6,1);
A=[0 1 0 1 0 0; -3*a -sg sg*(1-ep) 0 -a 0; -3*a 0 0 0 -a 0; ...
  -1 0 0 0 1 0; 0 b 0 0 -sg sg*(1-ep); 0 b 0 0 0 0]; 
B=[0 1 0 0 0 0; 0 0 0 0 1 0]'; s0=[0 0 0 0 1 1]';
Q=zeros(6); N=zeros(6,2); R=eye(2); Mf=eye(6); Qf=1e6;
[s,u,t]=tlqs(A,B,Q,N,R,tf,s0,Mf,Qf,psi,Ns); t=t/(2*pi); 
pw=(s(3,:)-s(2,:))/ep; rw=(s(6,:)-s(5,:))/ep; 
%
figure(1); clf; subplot(221), plot(t,s([1:3],:)); grid
legend('\phi','p','H_x'); axis([0 .25 -5 5]) 
subplot(222), plot(t,s([4:6],:)); grid
legend('\psi','r','H_z'); axis([0 .25 -5 5])
subplot(223), plot(t,u(1,:),t,-pw/10); grid 
xlabel('nt/2\pi'); legend('e_x','-p_w/10') 
axis([0 .25 -70 70]); subplot(224), plot(t,u(2,:),t,-rw/10); 
grid; xlabel('nt/2\pi'); legend('e_z','-r_w/10') 
axis([0 .25 -70 70])
%print -deps2 \book_do\figures\f05_20
	