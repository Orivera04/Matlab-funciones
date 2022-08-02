% Script p5_4_10.m; cart with inv. pendulum using TLQH; s=[y v th q]';
%                                                        2/93, 7/15/02
%
ep=.5; x0=[0 0 0 0]'; A=[0 1 0 0; 0 0 -ep 0; 0 0 0 1; 0 0 1 0];
B=[0 1 0 -1]'; Q=zeros(4); N=zeros(4,1); R=1; psi=[1 0 0 0]'; 
Mf=eye(4); tf=[6 15]; Ns=[50 100]; Sf=zeros(4);
for i=1:2,
 [x,u,t]=tlqh(A,B,Q,N,R,tf(i),x0,Sf,Mf,psi,Ns(i));
 figure(i); clf; subplot(211), plot(t,x(1,:)); grid; ylabel('y/l')
 subplot(212), plot(t,x(3,:),t,u); grid;  xlabel('t')
 legend('f','\theta');
end

