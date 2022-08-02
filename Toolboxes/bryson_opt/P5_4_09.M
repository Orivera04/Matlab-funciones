% Script p5_4_09.m; cart with pendulum using TLQH; s=[y v th q]';
%                                                   2/93, 7/15/02
%
ep=.5; x0=[0 0 0 0]'; psi=[1 0 0 0]'; A=[0 1 0 0; 0 0 ep 0; ...
0 0 0 1; 0 0 -1 0]; B=[0 1 0 -1]'; Q=zeros(4); N=zeros(4,1); R=1;
Mf=eye(4); tf=pi*[1 6]; Ns=[50 100]; Sf=zeros(4);
for i=1:2,
 [x,u,t]=tlqh(A,B,Q,N,R,tf(i),x0,Sf,Mf,psi,Ns(i));
 figure(i); clf; subplot(211), plot(t/(2*pi),x(1,:)); grid
 ylabel('y/l'); subplot(212), plot(t/(2*pi),x(3,:),t/(2*pi),u);
 grid; xlabel('t/2\pi'); legend('f','\theta')
end

