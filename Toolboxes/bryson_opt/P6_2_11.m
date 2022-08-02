% Script p6_2_11.m; A/C lateral control with rudder only (RHP zero);
% s[v r p ph]';                                          12/96, 7/17/02
%
A=[-.254 -1.76 0 .322; 2.55 -.76 -.35 0; -9.08 2.19 -8.4 0; 0 0 1 0];
B=[.1246 -4.6 2.55 0]'; C=[0 0 0 1]; D=0; R=1; 
%
% RL vs. Q where J=int(Q*Phi^2 + dr^2)dt:
Q=[1e-8 10.^[-2:.5:3] 1e8]; N=length(Q); ev=zeros(4,N);
for i=1:N, [k,S,ev(:,i)]=lqr(A,B,C'*Q(i)*C,R); end;
zc=ev(:,N); ev=ev(:,[1:N-1]);                     
%
figure(1); clf; plot(real(ev),imag(ev),'x',real(zc),imag(zc),'ro'); 
grid; axis([-9 0 0 9]); axis('square'); xlabel('Real(s) (1/sec)');
ylabel('Imag(s) (1/sec)');  
%
% Response to a command for phi=10 crad:
[k,S,ev]=lqr(A,B,C'*4*C,R); t=4*[0:.01:1]; dr=zeros(size(t));
s0=[-1 0 0 0]'; C1=[1 0 0 0; 0 1 0 0; -.254 0 0 0]; D1=[0 0 .1246]';
yc=10; [ph,y1,dr]=stepcmd(A,B,C,D,k,yc,C1,D1,t); v=y1(:,1); r=y1(:,2);
ay=y1(:,3); 
%
figure(2); clf; subplot(211), plot(t,ph,t,r,'r--',t,v,'k-.');
grid; legend('\phi (crad)','r (crad/sec)','v (ft/sec)',4) 
subplot(212), plot(t,dr,t,ay,'r--'); grid
legend('\delta r (crad)','ay (ft/sec/sec)',4); xlabel('Time (sec)')   
%
% Response time limited by RHP zero at 6.99 rad/sec. Occurs because
% this is a cascaded system - rudder first produces roll moment in the
% "wrong"  direction, which creates sideslip (v), which in turn produces
% roll moment (dihedral effect) in the right direction.
