% Script p5_5_15.m; pitch attitude change w. reaction wheel + desatur-
% ation with gravity torque using TDLQH (flg=1) or TDLQHR (flg=2); 
% x=[th dq dh]'; t in units of 1/wp, wp=pitch libration frequency,
% e=armature voltage in wp^2*R*Iy/N, (dq, qw) in wp, dh in Iy*wp,
% ep=J/Iy; sg=(c+N^2/R)(1/Iy+1/J)/wp; response to impulse that produces
% dq(0+)=dh(0+)=1;                                          7/97, 7/25/02
%
flg=1; sg=50/pi; ep=.02; A=[0 1 0; -1 -sg sg/(1+ep); -1 0 0]; B=[0 1 0]';
s0=[0 1 1]'; tf=pi/2; Ns=50; psi=[0 0 0]'; Qd=zeros(3); Nd=zeros(3,1);
Rd=1; Mf=eye(3); Sf=zeros(3); Ts=tf/Ns; [Ad,Bd]=c2d(A,B,Ts); nf=4;
if flg==1, [s,u]=tdlqh(Ad,Bd,Qd,Nd,Rd,s0,Sf,Mf,psi,Ts,Ns); 
elseif flg==2, [s,u]=tdlqhr(Ad,Bd,Qd,Nd,Rd,s0,Sf,Mf,psi,Ts,Ns,nf); 
end; t=tf*[0:1/Ns:1]/(2*pi); th=s(1,:); dqw=(s(3,:)-s(2,:))/ep;
uh=[u u(Ns)]; 
% 
figure(1); clf; subplot(211), plot(t,s(1,:),t,s(2,:),'r--',t,s(3,:),...
     'k-.');grid; axis([0 .25 -2.5 2.5]); legend('\theta','dq','dh',3)
subplot(212), zohplot(t,uh); grid; hold on; plot(t,dqw,'r--'); hold off
axis([0 .25 -80 120]); xlabel('\omega t/2\pi'); legend('de','dq_w',2)
text(.075,60,'1/\sigma = .01*(2 \pi)/ \omega')
	