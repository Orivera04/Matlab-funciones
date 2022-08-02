% Script f05_23.m; 747 coordinated S-turn; s=[v r p phi 
% psi y]'; u=[da dr]'; xdot=Ax+Bu, ay=Cx+Du; J=ef'*Qf*ef
% +int[(8ay)^2+da^2+dr^2]dt, ef=Mf*x(tf)-psi; units ft, 
% sec, crad;                                9/97, 4/4/02
%
A=[-.089 -2.19 0 .319 0 0; .076 -.217 -.166 0 0 0; ...
   -.602 .327 -.975 0 0 0; 0 .15 1 0 0 0; 0 1 0 0 ...
   0 0; 1 0 0 0 2.19 0]; B=[0 .0327; .0264 -.151; ...
   .227 .0636; zeros(3,2)]; D=[0 .0327]; 
C=[-.089 0 0 0 0 0]; Qz=8^2; Q=C'*Qz*C; N=C'*Qz*D; 
R=eye(2)+D'*Qz*D; Mf=eye(6); Qf=1e6*eye(6);
x0=[0 0 0 0 0 0]'; psi=[0 0 0 0 0 10]'; tf=10;
Ns=50; [x,u,t]=tlqs(A,B,Q,N,R,tf,x0,Mf,Qf,psi,Ns);
ay=C*x+D*u;
%
figure(1); clf; subplot(211), plot(t,x(6,:),t,ay,...
  'r--'); grid; legend('y (ft)','a_y (ft/s^2)',2) 
axis tight; subplot(212), plot(t,x(4,:),t,x(5,:),'r--'); 
grid; axis tight; xlabel('Time (sec)'); ylabel('crad'); 
legend('\phi','\psi')
%print -deps2 \book_do\figures\f05_23
%
figure(2); clf; subplot(211), plot(t,u(1,:),t,...
    u(2,:),'r--'); grid; axis tight; ylabel('crad') 
legend('\delta a','\delta r'); subplot(212),
plot(t,x(1,:)); axis tight; grid; xlabel('Time (sec)')
ylabel('v (ft/sec)')
%print -deps2 \book_do\figures\f05_24
	

	
