% Script p5_5_18.m; 747 S-turn using TDLQH (flg=1) or TDLQHR (flg=2);
% s=[v r p phi psi y]'; u=[da dr]'; ay=Cx+Du; J=int[(8ay)^2+da^2+dr^2]dt,
% Mf*x(tf)=psi; units ft, sec, crad;                         7/97, 7/25/02
%
flg=2; A=[-.089 -2.19 0 .319 0 0; .076 -.217 -.166 0 0 0; -.602 ...
  .327 -.975 0 0 0; 0 .15 1 0 0 0; 0 1 0 0 0 0; 1 0 0 0 2.19 0]; 
B=[0 .0327; .0264 -.151; .227 .0636; zeros(3,2)]; C=[-.089 0 0 0 0 0];
D=[0 .0327]; Qz=8^2; Q=C'*Qz*C; N=C'*Qz*D; R=eye(2)+D'*Qz*D; Mf=eye(6);
Sf=zeros(6); s0=[0 0 0 0 0 0]'; psi=[0 0 0 0 0 10]'; tf=10; Ns=50;
Ts=tf/Ns; [Ad,Bd,Qd,Nd,Rd]=cvrtj(A,B,Q,N,R,Ts); t=tf*[0:1/Ns:1];
if flg==1, [s,u]=tdlqh(Ad,Bd,Qd,Nd,Rd,s0,Sf,Mf,psi,Ts,Ns); 
elseif flg==2, nf=7; [s,u]=tdlqhr(Ad,Bd,Qd,Nd,Rd,s0,Sf,Mf,psi,Ts,Ns,nf);
end; uh=[u u(:,Ns)]; ay=C*s+D*uh;
%
figure(1); clf; subplot(211), plot(t,s(6,:),t,ay,'r--'); grid
legend('y (ft)','a_y (ft/s^2)',2); subplot(212)
plot(t,s(4,:),t,s(5,:),'r--'); grid; xlabel('Time (sec)')
legend('\phi','\psi',3); ylabel('crad')
%
figure(2); clf; subplot(211), zohplot(t,uh(1,:)); hold on
zohplot(t,uh(2,:),'r--'); hold off; grid 
legend('\delta a','\delta r',2); ylabel('crad'); subplot(212)
plot(t,s(1,:)); grid; xlabel('Time (sec)'); ylabel('v (ft/sec)')

	

	
