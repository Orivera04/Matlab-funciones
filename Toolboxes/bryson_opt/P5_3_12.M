% Script p5_3_12.m; position change of a hovering helicopter using
% TDLQS; x=[u q th y]'; u=dcy; units ft, sec, crad, deci-in (for 
% dcy);                                               2/93, 7/2/02
%
tf=4; N=60; Ts=tf/N; Qf=1e4; Mf=eye(4); psi=[0 0 0 10]';
A=[-.0257 .0130 -.322 0; 1.26 -1.765 0 0; 0 1 0 0; 1 0 0 0]; 
B=[.0860 -7.41 0 0]'; [Ph,Ga]=c2d(A,B,Ts); Qd=zeros(4); 
Nd=zeros(4,1); Rd=1; x0=[0 0 0 0]';
[x,u]=tdlqs(Ph,Ga,Qd,Nd,Rd,x0,Mf,Qf,psi,Ts,N);
t=tf*[0:1/N:1]; uh=[u u(N)]; 
%
figure(1); clf; subplot(211), plot(t,x(4,:)); grid
ylabel('y (ft)'); subplot(212), plot(t,x([1 3],:)); grid; hold on
zohplot(t,uh); hold off; xlabel('Time (sec)'); 
legend('u (ft/sec)','\theta (crad)','\delta_{cy} (deci-in)',2)

