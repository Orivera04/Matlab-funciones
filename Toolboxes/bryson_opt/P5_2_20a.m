% Script p5_2_20a.m; 747 coordinated S-turn; s=[v r p phi psi y]';
% u=[da dr]'; xdot=Ax+Bu, ay=Cx+Du; J=ef'*Qf*ef+int[(8ay)^2+
% da^2+dr^2]dt, ef=Mf*x(tf)-psi;  units ft, sec, crad; 9/97, 7/11/02
%
flg=2;
A=[-.089 -2.19 0 .319 0 0; .076 -.217 -.166 0 0 0; -.602 .327 ...
   -.975 0 0 0; 0 .15 1 0 0 0; 0 1 0 0 0 0; 1 0 0 0 2.19 0]; 
B=[0 .0327; .0264 -.151; .227 .0636; zeros(3,2)]; D=[0 .0327];
C=[-.089 0 0 0 0 0]; Qz=8^2; Q=C'*Qz*C; N=C'*Qz*D; R=eye(2)+D'*Qz*D;
Mf=eye(6); Qf=1e6*eye(6); x0=[0 0 0 0 0 0]'; psi=[0 0 0 0 0 10]'; 
tf=10; Ns=50; tol=1e-4;
if flg==1, [x,u,t]=tlqs(A,B,Q,N,R,tf,x0,Mf,Qf,psi,Ns);
   ay=C*x+D*u; v=x(1,:); phi=x(4,:); psi=x(5,:); y=x(6,:); 
elseif flg==2, [x,u,t]=tlqsr(A,B,Q,N,R,tf,x0,Mf,Qf,psi,tol); 
   ay=C*x'+D*u; v=x(:,1); phi=x(:,4); psi=x(:,5); y=x(:,6); 
end
%
figure(1); clf; subplot(211), plot(t,y,t,ay,'r--'); grid 
legend('y (ft)','a_y (ft/s^2)',2); axis([0 tf -1 10]); subplot(212)
plot(t,phi,t,psi); grid; axis([0 tf -3 3]); xlabel('Time (sec)'); 
legend('\phi','\psi (crad)')
%
figure(2); clf; subplot(211), plot(t,u); grid
legend('\delta a','\delta r (crad)'); subplot(212), plot(t,v);
grid; xlabel('Time (sec)'); ylabel('v (ft/sec)')

	

	
