% Script f06_04.m; controlling tip deflection of a flexible arm 
% with shoulder torque; x=[th1 q1 th2 q2]'; u=T; y in l, time 
% in 1/om, om=2.782*sqrt(k/ml^2), q in om, T in k; xdot=Ax+Bu;
%                                                  7/92, 4/4/02
%
ep=.4251; A=[0 1 0 0;-ep 0 ep 0;0 0 0 1;1-ep 0 -1+ep 0]; 
B=[0 .2003 0 -.2248]'; C=[1 0 1 0]; D=0; Q=100; R=1;
k=lqr(A,B,C'*Q*C,R); tf=2*(2*pi); t=tf*[0:.01:1]';
w=zeros(size(t)); x0=[-.5 0 -.5 0]';
[y,x]=lsim(A-B*k,B,C,D,w,t,x0); u=-x*k'; t=t/(2*pi);
%
figure(1); clf; subplot(211), plot(t,y); grid 
axis([0 2 -1.2 .2]); text(.7,-.5,'Tip Deflection')
subplot(212), plot(t,x(:,1),t,x(:,3),t,u/5,'-'); grid 
axis([0 2 -2 2]); xlabel('\omega t/(2\pi)')
text(.1,1.5,'Torque/5'); text(.3,.8,'\theta_1')
text(.5,-1.3,'\theta_2')     
%print -deps2 \book_do\figures\f06_04
