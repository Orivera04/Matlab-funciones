% Script p6_2_13.m; 747 coordinated S-turn w. const. gains; u=[da dr]'; 
% s=[v r p phi psi y]'; y1=[y ay]'; J=int(y^2+64*ay^2+da^2+dr^2)dt,
% units ft, sec, crad;                                     9/97, 7/17/02
%
A=[-.089 -2.19 0 .319 0 0; .076 -.217 -.166 0 0 0; -.602 .327 -.975 ...
      0 0 0; 0 .15 1 0 0 0; 0 1 0 0 0 0; 1 0 0 0 2.19 0];
B=[0 .0327; .0264 -.151; .227 .0636; zeros(3,2)]; D=[0 0; 0 .0327];
C=[0 0 0 0 0 1; -.089 0 0 0 0 0]; Qz=diag([1 64]); Q=C'*Qz*C; N=C'*Qz*D;
R=eye(2)+D'*Qz*D; k=lqr(A,B,Q,R,N); s0=[0 0 0 0 0 -10]'; t=25*[0:.01:1];
sys=ss(A-B*k,B,C,D); [y1,t,s]=initial(sys,s0,t); u=-s*k'; 
%
figure(1); clf; subplot(211), plot(t,y1(:,1),t,y1(:,2),'r--'); grid
legend('y (ft)','a_y (ft/s^2)',4) 
subplot(212), plot(t,s(:,4),t,s(:,5),'r--'); grid; xlabel('Time (sec)')
ylabel('crad'); legend('\phi','\psi')
%
figure(2); clf; subplot(211), plot(t,u(:,1),t,u(:,2),'r--'); grid
axis([0 25 -5 10]); ylabel('crad'); legend('\delta a','\delta r')
subplot(212), plot(t,s(:,1)); grid; xlabel('Time (sec)')
ylabel('v (ft/sec)')
	

	
