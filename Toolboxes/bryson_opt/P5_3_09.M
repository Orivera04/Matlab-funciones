% Script p5_3_09.m; cart with pendulum using TDLQS; M=cart mass,
% m=pendulum mass, l=pendulum length, u=force on cart, y=displ. 
% of cart, th=angle of pendulum; x=[y ydot th thdot]'; y in l, 
% ep=m/(m+M), t in sqrt[Ml/(M+m)g]/2*pi, u in (M+m)g, 
% psi=Mf*x(N);                                    2/95, 6/30/02
%
tf=[2 10]*pi; N=[20 60]; ep=.5; x0=[0 0 0 0]'; B=[0 1 0 -1]';
A=[0 1 0 0; 0 0 ep 0; 0 0 0 1; 0 0 -1 0]; psi=[1 0 0 0]';
Qd=zeros(4); Nd=zeros(4,1); Rd=1; Qf=1e4; Mf=eye(4);
for i=1:2, Ts=tf(i)/N(i); [Ph,Ga]=c2d(A,B,Ts);
  [x,u]=tdlqs(Ph,Ga,Qd,Nd,Rd,x0,Mf,Qf,psi,Ts,N(i));
  t=[0:1/N(i):1]; uh=[u u(N(i))]; figure(i); clf; subplot(211)
  plot(t,x(1,:)); grid; ylabel('y'); subplot(212)
  zohplot(t,uh); hold on; plot(t,x(3,:),'-'); grid; hold off
  xlabel('t/t_f'); legend('\theta','u')
end