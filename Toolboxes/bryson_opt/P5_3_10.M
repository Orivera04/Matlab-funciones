% Script p5_3_10.m; cart with inv. pend. using TDLQS; M=cart mass,
% m=pendulum mass, l=pendulum length, u=sp. force on cart, y=cart 
% displ., th=pend. angle; x=[y ydot th thdot]'; y in l, ep=m/(m+M); 
% t in sqrt[Ml/(M+m)g]/2*pi, u in (M+m)g,              2/95, 7/2/02
%
tf=[6 30]; N=[20 60]; ep=.5; x0=[-1 0 0 0]'; A=[0 1 0 0; 0 0 ...
   -ep 0; 0 0 0 1; 0 0 1 0]; B=[0 1 0 -1]'; Qf1=[1e4 1e3]; 
Mf=eye(4); psi=[0 0 0 0]'; Qd=zeros(4); Nd=zeros(4,1); Rd=1;  
for i=1:2, Ts=tf(i)/N(i); Qf=Qf1(i); [Ph,Ga]=c2d(A,B,Ts); 
   [x,u]=tdlqs(Ph,Ga,Qd,Nd,Rd,x0,Mf,Qf,psi,Ts,N(i));
   t=tf(i)*[0:1/N(i):1]; uh=[u u(N(i))]; figure(i); subplot(211),
   plot(t,x(1,:)); grid; ylabel('y'); subplot(212), zohplot(t,uh);
   grid; hold on; plot(t,x(3,:),'-'); hold off; xlabel('t')
   ylabel('\theta & u')
end