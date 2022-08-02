% Script f06_03.m; controlling tip deflection of a flexible arm 
% with shoulder torque; x=[th1 q1 th2 q2]'; u=T; y in l, time 
% in 1/om, om=2.782*sqrt(k/ml^2), q in om, T in k; xdot=Ax+Bu;
%                                                  7/92, 4/4/02
%
a=.0245; b=1.265; num=a^2*[1 0 -2*b^2 0 b^4];
den=[1 0 2 0 1 0 0 0 0];
%
figure(1); rlocus(num,den); grid; 
axis([-1.5 0 0 1.5]); hold on; ep=.005;
A=[0 1 0 0; -.4251 0 .4251 0; 0 0 0 1; .5749 0 -.5749 0]; 
B=[0 .2003 0 -.2248]'; C=[1 0 1 0]; D=0;
Q=[ep^2 3 10 30 100 300 1000 3000 10000 1e10]'; R=1; 
for i=1:10,
 k=lqr(A,B,C'*Q(i)*C,R); ev(:,i)=eig(A-B*k);
end; zc=ev(:,10); ev=ev(:,[1:9]);
plot(real(ev),imag(ev),'x',real(zc),imag(zc),'o');
hold off; xlabel('Real(s)');  ylabel('Imag(s)')
text(-.95,1.35,'Q/R=10^4'); text(-.45,1.1,'10^2')
text(-.2,.97,'10'); text(-.05,.95,'1')
text(-.92,.37,'10^4'); text(-.65,.37,'10^2')
text(-.37,.32,'10'); text(-.2,.22,'1'); hold off
%print -deps2 \book_do\figures\f06_03
