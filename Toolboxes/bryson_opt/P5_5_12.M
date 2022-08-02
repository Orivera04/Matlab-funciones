% Script p5_5_12.m; discrete HTC of hover position of OH6A helicopter
% using TDLQH (flg=1) or TDLQHR (flg=2); s=[u q th y]'; u=de; units ft,
% sec, crad, deci-in;                                     2/93, 7/25/02
%
flg=1; tf=4; N=100; Ts=tf/N; s0=[0 0 0 0]'; psi=[0 0 0 10]'; Mf=eye(4);
Sf=zeros(4); A=[-.0257 .0130 -.322 0; 1.260 -1.765 0 0; 0 1 0 0; ...
  1 0 0 0]; B=[.0860 -7.41 0 0]'; Qd=zeros(4); Nd=zeros(4,1); Rd=1;
[Ph,Ga]=c2d(A,B,Ts); nf=5;
if flg==1, [s,u]=tdlqh(Ph,Ga,Qd,Nd,Rd,s0,Sf,Mf,psi,Ts,N);
elseif flg==2, [s,u]=tdlqhr(Ph,Ga,Qd,Nd,Rd,s0,Sf,Mf,psi,Ts,N,nf);
end; uh=[u u(N)]; t=tf*[0:1/N:1]; y=s(4,:);
% 
figure(1); clf; subplot(211), plot(t,y); grid; axis([0 4 0 10])
text(1.6,-3.4,'y (ft)'); subplot(212), zohplot(t,uh); grid; hold on
plot(t,s(3,:)); hold off; xlabel('Time (sec)')
text(.8,5,'\delta e (deci-in)'); text(1.3,-15,'\theta (crad)')
	