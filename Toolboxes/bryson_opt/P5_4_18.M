% Script p5_4_18.m; coordinated S-turn of 747; s=[v r p phi psi y]'; 
% u=[da dr]'; xdot=Ax+Bu, z=Cx+Du=ay; J=int[(8ay)^2+da^2+dr^2]dt,
% Mf*x(tf)=psi; units ft, sec, crad;                   7/97, 7/25/02
%
flg=1; A=[-.089 -2.19 0 .319 0 0; .076 -.217 -.166 0 0 0; -.602 ...
   .327 -.975 0 0 0; 0 .15 1 0 0 0; 0 1 0 0 0 0; 1 0 0 0 2.19 0];
B=[0 .0327; .0264 -.151; .227 .0636; zeros(3,2)]; D=[0 .0327]; 
C=[-.089 0 0 0 0 0]; Qz=8^2; Q=C'*Qz*C; N=C'*Qz*D; R=eye(2)+D'*Qz*D;
Mf=eye(6); Sf=zeros(6); x0=[0 0 0 0 0 0]'; psi=[0 0 0 0 0 10]'; 
tf=8; Ns=50; 
if flg==1, [x,u,t]=tlqh(A,B,Q,N,R,tf,x0,Sf,Mf,psi,Ns); ay=C*x+D*u;
elseif flg==2, t1=.8*tf; tol=1e-4; 
 	[x,u,t]=tlqhr(tf,x0,Sf,psi,t1,tol); ay=C*x'+D*u;
end
%
figure(1); clf; subplot(211), plot(t,x(6,:),t,ay); grid
ylabel('y (ft) & ay (ft/s^2)'); subplot(212), plot(t,x([4 5],:));
grid; xlabel('Time (sec)'); ylabel('Phi & Psi (crad)')
%
figure(2); clf; subplot(211), plot(t,u); grid
ylabel('da & dr (crad)'); subplot(212), plot(t,x(1,:)); grid
xlabel('Time (sec)'); ylabel('v (ft/sec)')

	

	
