% Script p5_3_18.m; coordinated S-turn of 747; u=[da dr]';
% s=[v r p phi psi y]'; xdot=Ax+Bu, z=Cx+Du=ay; J=ef'*Qf*ef+
% int[(8ay)^2+da^2+dr^2]dt, ef=Mf*x(tf)-psi; units ft, sec, crad; 
%                                                     7/97, 7/3/02
%
A=[-.089 -2.19 0 .319 0 0; .076 -.217 -.166 0 0 0; -.602 ...
   .327 -.975 0 0 0; 0 .15 1 0 0 0; 0 1 0 0 0 0; 1 0 0 0 2.19 0];
B=[0 .0327; .0264 -.151; .227 .0636; zeros(3,2)];
C=[-.089 0 0 0 0 0]; D=[0 .0327];
Qz=8^2; Q=C'*Qz*C; N=C'*Qz*D; R=eye(2)+D'*Qz*D; Mf=eye(6); Qf=1e6;
x0=[0 0 0 0 0 0]'; psi=[0 0 0 0 0 10]'; tf=8; Ns=50; Ts=tf/Ns;
[Ad,Bd,Qd,Nd,Rd]=cvrtj(A,B,Q,N,R,Ts);
[x,u]=tdlqs(Ad,Bd,Qd,Nd,Rd,x0,Mf,Qf,psi,Ts,Ns);
uh=[u u(:,Ns)]; ay=C*x+D*uh; t=tf*[0:1/Ns:1];
%
figure(1); clf; subplot(211), plot(t,x(6,:),t,ay); grid
legend('y (ft)','a_y (ft/s^2)',2); subplot(212), plot(t,x([4 5],:)); 
grid; xlabel('Time (sec)'); legend('\phi','\psi'); ylabel('crad')
%
figure(2); clf; subplot(211), zohplot(t,uh); grid
legend('\delta_a','\delta_r'); ylabel('crad'); subplot(212)
plot(t,x(1,:)); grid; xlabel('Time (sec)'); ylabel('v (ft/sec)')

	

	
