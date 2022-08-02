% Script e05_5_1.m; discrete min int sq control for cart w. pendulum;
% zero terminal error; M=cart mass, m=pendulum mass, l=pendulum length;
% u=force on cart, y=displacement of cart, th=angle pendulum; x=[y ydot
% th thdot]'; t in sqrt[Ml/(M+m)g]/2*pi, u in (M+m)g, y in l, ep=m/(m+M);
% psi=Mf*x(N);			                                    4/97, 6/24/02
%
tf1=[2 10]*pi; Na=[32 80]; ep=.5; x0=[0 0 0 0]'; psi=[1 0 0 0]';
A=[0 1 0 0; 0 0 ep 0; 0 0 0 1; 0 0 -1 0]; B=[0 1 0 -1]';
Qd=zeros(4); Nd=zeros(4,1); Rd=1; Sf=zeros(4); Mf=eye(4);
for i=1:2, tf=tf1(i); Nb=Na(i); Ts=tf/Nb;
 [Ph,Ga]=c2d(A,B,Ts); [x,u]=tdlqh(Ph,Ga,Qd,Nd,Rd,x0,Sf,Mf,psi,Ts,Nb);        
 uh=[u u(Nb)]; t=tf*[0:1/Nb:1]/(2*pi); 
 figure(i); clf; subplot(211), plot(t,x(1,:)); grid; axis([0 tf/(2*pi) 0 1]) 
 hold on; ylabel('y'); subplot(212), zohplot(t,uh); grid; hold on 
 plot(t,x(3,:),'r--'); hold off; xlabel('t/2\pi'); legend('\theta','u') 
end
	