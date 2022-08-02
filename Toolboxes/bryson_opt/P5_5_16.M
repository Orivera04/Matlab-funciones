% Script p5_5_16.m; dumping roll/yaw angular momentum; oblate S/C with 
% symmetry axis cross-track; I=Ix=Iz=2*Iy/3 ==> a=b=.5; sg=50/pi; ep=.02;
% s=[phi p Hx psi r Hz]'; u=[ex ez]'; time in units of 1/n, (p r Hx/Ix 
% Hz/Iz sg) in n, u in R*I*n^2/N;                           7/91, 7/25/02
%
flg=1; tf=pi/2; Ns=100; a=.5; b=.5; sg=50/pi; ep=.02; psi=zeros(6,1);
A=[0 1 0 1 0 0; -3*a -sg sg*(1-ep) 0 -a 0; -3*a 0 0 0 -a 0; ...
      -1 0 0 0 1 0; 0 b 0 0 -sg sg*(1-ep); 0 b 0 0 0 0]; 
B=[0 1 0 0 0 0; 0 0 0 0 1 0]'; s0=[0 1 1 0 0 0]'; Qd=zeros(6);
Nd=zeros(6,2); Rd=eye(2); Mf=eye(6); Sf=zeros(6); Ts=tf/Ns; nf=7;
[Ad,Bd]=c2d(A,B,Ts); 
if flg==1, [s,u]=tdlqh(Ad,Bd,Qd,Nd,Rd,s0,Sf,Mf,psi,Ts,Ns);
elseif flg==2, [s,u]=tdlqhr(Ad,Bd,Qd,Nd,Rd,s0,Sf,Mf,psi,Ts,Ns,nf);
end; t=tf*[0:1/Ns:1]/(2*pi); uh=[u u(:,Ns)]; pw=(s(3,:)-s(2,:))/ep;
rw=(s(6,:)-s(5,:))/ep; 
%
figure(1); clf; subplot(221), plot(t,s([1:3],:)); grid
legend('\phi','p','H_x'); axis([0 .25 -1 1.5]); subplot(222)
plot(t,s([4:6],:)); grid; legend('\psi','r','H_z')
axis([0 .25 -1 1.5]); subplot(223), zohplot(t,uh(1,:)); grid; hold on
plot(t,-pw/10); hold off; xlabel('nt/2\pi'); legend('e_x','-p_w/10')
axis([0 .25 -20 20]); subplot(224), zohplot(t,uh(2,:)); grid; hold on
plot(t,-rw/10); hold off; xlabel('nt/2\pi'); axis([0 .25 -20 20])
legend('e_z','-r_w/10') 	


	
	