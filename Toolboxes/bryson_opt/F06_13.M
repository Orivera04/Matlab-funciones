% Script f06_13.m; response OH-6A helicopter to IC's u=1,
% q=0, theta=0;                              2/92, 4/4/02
%
A=[-.0257 .0130 -.322; 1.260 -1.765 0; 0 1 0];
B=[.0860 -7.41 0]'; C=[1 0 0]; R=1; Ts=.1; Q=C'*10*C;  
[Ad,Bd]=c2d(A,B,Ts); k=lqrd(A,B,Q,R,Ts);
u=zeros(60,1); xo=[1 0 0]';  t=[0:.1:5.9]'; 
[y,x]=dlsim(Ad-Bd*k,Bd,C,0,u,xo); del=-x*k';
%
figure(1); clf; subplot(211), plot(t,x(:,[1 3])); grid
text(2.5,1.1,'\theta (crad)'); text(.5,-.3,'u (ft/sec)')
subplot(212), zohplot(t,del); grid
text(1.5,-1,'\delta_e (deci-in)'); xlabel('Time (sec)')
%print -deps2 \book_do\figures\f06_13