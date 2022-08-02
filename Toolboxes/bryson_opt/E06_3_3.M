% Script e06_3_3.m; RRL for OH6a helicopter;              2/92, 6/24/02
%
A=[-.0257 .0130 -.322;1.260 -1.765 0;0 1 0]; B=[.0860 -7.41 0]'; 
C=[1 0 0]; N=[0 0 0]'; R=1; Ts=.1; Q1=[1e-8 1 3 10 30 100 300 1000 ...
  3000 10000]; for i=1:10, Q=C'*Q1(i)*C; [Ad,Bd]=c2d(A,B,Ts);
  k=lqrd(A,B,Q,R,Ts); p(:,i)=eig(Ad-Bd*k); end
for i=1:91, xc(i)=cos(pi*i/180); yc(i)=sin(pi*i/180); end
%
figure(1); clf; plot(real(p),imag(p),'x',xc,yc); grid; axis([0 1 0 1])
axis('square'); xlabel('Real(z)'); ylabel('Imag(z)')
text(.58,.4,'Q/R=10^4'); text(.7,.29,'10^3'); text(.74,.2,'10^2')
text(.83,.13,'10'); text(.28,.04,'10^4'); text(.53,.04,'10^3')
text(.66,.04,'10^2'); text(.76,.04,'10')
%
% Response OH-6A helicopter to IC's u = 1, q = 0, theta = 0.
Q=C'*10*C; [Ad,Bd]=c2d(A,B,Ts); k=lqrd(A,B,Q,R,Ts); u=zeros(60,1);
xo=[1 0 0]'; [y,x]=dlsim(Ad-Bd*k,Bd,C,0,u,xo); del=-x*k'; 
t=[0:.1:5.9]';

figure(2); clf; subplot(211), plot(t,x(:,[1 3])); grid
text(2.5,1.1,'\theta (crad)'); text(.5,-.3,'u (ft/sec)')
subplot(212), zohplot(t,del); grid; text(1.5,-1,'\delta (deci-in)')
xlabel('Time (sec)')