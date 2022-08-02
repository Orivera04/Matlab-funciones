% Script p5_2_20b.m; 747 S-turn with rudder only (u=dr); s=[v r p phi 
% psi y]'; xdot=Ax+Bu, ay=Cx+Du; J=ef'*Qf*ef+int(dr^2)dt, ef=Mf*x(tf)
% -psi, tf=12 sec; units ft, sec, crad;                10/97, 6/30/02
%
A=[-.089 -2.19 0 .319 0 0; .076 -.217 -.166 0 0 0; -.602 .327 ...
   -.975 0 0 0; 0 .15 1 0 0 0; 0 1 0 0 0 0; 1 0 0 0 2.19 0];
B=[.0327; -.151; .0636; zeros(3,1)]; C=[-.089 0 0 0 0 0]; D=.0327;
Qz=8^2; Q=C'*Qz*C; N=C'*Qz*D; R=1+D'*Qz*D; Mf=eye(6); Qf=1e6*eye(6);
s0=[0 0 0 0 0 0]'; psi=[0 0 0 0 0 10]'; tf=12; Ns=50; 
[x,u,t]=tlqs(A,B,Q,N,R,tf,s0,Mf,Qf,psi,Ns); ay=C*x+D*u;
%
figure(1); clf; subplot(211), plot(t,x(6,:),t,ay,'r--'); grid
legend('y (ft)','a_y (ft/s^2)',2); subplot(212), plot(t,x([4 5],:));
grid; xlabel('Time (sec)'); ylabel('crad'); text(3.5,2.5,'\phi')
text(3.5,-.5,'\psi')
%
figure(2); clf; subplot(211), plot(t,u); grid
ylabel('\delta r (crad)'); subplot(212), plot(t,x(1,:)); grid
xlabel('Time (sec)'); ylabel('v (ft/sec)')
		

	
