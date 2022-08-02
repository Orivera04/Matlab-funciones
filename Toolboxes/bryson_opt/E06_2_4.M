% Script e06_2_4.m; controlling tip deflection of a flexible robot arm
% with shoulder torque; x=[th1 q1 th2 q2]'; u=T; y in l, time in 1/om, 
% om=2.782*sqrt(k/ml^2), q in om, T in k; xdot=Ax+Bu;    7/92, 6/24/02
%
a=.0245; b=1.265; num=a^2*[1 0 -2*b^2 0 b^4]; den=[1 0 2 0 1 0 0 0 0];
%
figure(1); clf; rlocus(num,den); grid; axis('square'); hold on 
axis([-1.5 0 0 1.5]); ep=.4251; ep1=.005;A=[0 1 0 0;-ep 0 ep 0;0 0 ...
  0 1;1-ep 0 -1+ep 0]; B=[0 .2003 0 -.2248]'; C=[1 0 1 0]; D=0;
Q=[ep1^2 3 10 30 100 300 1000 3000 10000 1e10]'; R=1; 
for i=1:10, k=lqr(A,B,C'*Q(i)*C,R); ev(:,i)=eig(A-B*k); end 
zc=ev(:,10); ev=ev(:,[1:9]);
%
plot(real(ev),imag(ev),'x',real(zc),imag(zc),'o'); hold off
xlabel('Real(s)');  ylabel('Imag(s)'); text(-.95,1.35,'Q/R=10^4');
text(-.45,1.1,'10^2'); text(-.2,.97,'10'); text(-.05,.95,'1')
text(-.92,.37,'10^4'); text(-.65,.37,'10^2'); text(-.37,.32,'10')
text(-.2,.22,'1')
%
Q=100; R=1; k=lqr(A,B,C'*Q*C,R); tf=4*pi; t=tf*[0:.01:1]';
w=zeros(size(t)); xo=[-.5 0 -.5 0]'; [y,x]=lsim(A-B*k,B,C,D,w,t,xo); 
u=-x*k'; t=t/(2*pi);
%
figure(2); clf; subplot(211), plot(t,y); grid; axis([0 2 -1.2 .2])
text(.7,-.5,'Tip Deflection'); subplot(212), plot(t,x(:,1),t,...
x(:,3),t,u/5,'-'); grid; axis([0 2 -2 2]); xlabel('\omega t/(2\pi)')
text(.1,1.5,'Torque/5'); text(.3,.8,'\theta_1')
text(.5,-1.3,'\theta_2')  