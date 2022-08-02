% Script p5_3_15.m; pitch attitude change w. reaction wheel + desatur-
% ation with gravity torque using TDLQS; x=[th dq dh]'; t in units of
% 1/wp, wp=pitch libration frequency, e=armature  voltage in wp^2*R*Iy/N,
% (dq, qw) in wp, dh in Iy*wp, ep=J/Iy; sg=(c+N^2/R)(1/Iy+1/J)/wp;
% response to impulse that produces dq(0+)=dh(0+)=1;        7/97, 7/3/02
%
sg=50/pi; ep=.02; A=[0 1 0; -1 -sg sg/(1+ep); -1 0 0]; B=[0 1 0]';
s0=[0 1 1]'; tf=pi/2; N=50; Ts=tf/N; [Ad,Bd]=c2d(A,B,Ts);
psi=[0 0 0]'; Qd=zeros(3); Nd=zeros(3,1); Rd=1; Qf=1e6; Mf=eye(3);
[s,u]=tdlqs(Ad,Bd,Qd,Nd,Rd,s0,Mf,Qf,psi,Ts,N); th=s(1,:);
dqw=(s(3,:)-s(2,:))/ep; uh=[u u(N)]; t=tf*[0:1/N:1]/(2*pi); 
% 
figure(1); clf; subplot(211), plot(t,s([1:3],:)); grid 
axis([0 .25 -2.5 2.5]); legend('\theta','dq','dh'); subplot(212)
zohplot(t,uh); grid; hold on; plot(t,dqw); hold off
axis([0 .25 -80 120]); xlabel('\omega t/(2\pi)'); ylabel('de, dq_w')
text(.05,60,'1/\sigma = .01*(2\pi)/\omega')
	