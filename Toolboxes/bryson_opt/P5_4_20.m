% Script p5_4_20.m; 747 S-turn; s=[v r p phi psi y]'; u=[da dr]'; 
% xdot=Ax+Bu, ay=Cx+Du; J=int[(8ay)^2+da^2+dr^2]dt, Mf*x(tf)=psi; 
% units ft, sec, crad;                                 7/97, 7/25/02
%
flg=1; A=[-.089 -2.19 0 .319 0 0; .076 -.217 -.166 0 0 0;...
   -.602 .327 -.975 0 0 0; 0 .15 1 0 0 0; 0 1 0 0 0 0; ...
   1 0 0 0 2.19 0]; B=[0 .0327; .0264 -.151; .227 .0636; ...
   zeros(3,2)]; C=[-.089 0 0 0 0 0]; D=[0 .0327]; Qz=8^2; Q=C'*Qz*C; 
N=C'*Qz*D; R=eye(2)+D'*Qz*D; Mf=eye(6); Ns=50; Sf=zeros(6);
s0=[0 0 0 0 0 0]'; psi=[0 0 0 0 0 10]'; tf=8;
if flg==1, [x,u,t]=tlqh(A,B,Q,N,R,tf,s0,Sf,Mf,psi,Ns); ay=C*x+D*u;
elseif flg==2, t1=.9*tf; tol=1e-4;
 [x,u,t]=tlqhr(A,B,Q,N,R,tf,s0,Sf,Mf,psi,t1,tol); ay=C*x'+D*u;
end
%
figure(1); clf; subplot(211), plot(t,x(6,:),t,ay,'r--'); grid
legend('y (ft)','a_y (ft/s^2)',2); subplot(212), plot(t,x([4 5],:));
grid; xlabel('Time (sec)'); legend('\phi','\psi (crad)',2)
%
figure(2); clf; subplot(211), plot(t,u); grid 
legend('\delta a','\delta r (crad)',2); subplot(212), plot(t,x(1,:));
grid; xlabel('Time (sec)'); ylabel('v (ft/sec)')

	

	
