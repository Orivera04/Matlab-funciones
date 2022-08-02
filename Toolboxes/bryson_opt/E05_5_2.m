% Script e05_5_2.m; discrete min int sq control for cart w. pendulum;
% zero terminal error, Riccati solution; M=cart mass, m=pendulum mass, 
% l=pendulum length; u=force on cart, y=displacement of cart, th=angle
% of pendulum; x=[y ydot th thdot]'; t in sqrt[Ml/(M+m)g]/2*pi, u in 
% (M+m)g, y in l, ep=m/(m+M); psi=Mf*x(N); two solutions, one for tf
% =2*pi and the other for tf=10*pi;                     4/97, 5/29/02
%
tf1=[1 5]*(2*pi); Ns=80; ep=.5; x0=[0 0 0 0]'; psi=[1 0 0 0]';
A=[0 1 0 0; 0 0 ep 0; 0 0 0 1; 0 0 -1 0]; B=[0 1 0 -1]';
Qd=zeros(4); Nd=zeros(4,1); Rd=1; Sf=zeros(4); Mf=eye(4); nf=5;
for i=1:2, tf=tf1(i); Ts=tf/Ns; [Ph,Ga]=c2d(A,B,Ts);
 [x,u]=tdlqhr(Ph,Ga,Qd,Nd,Rd,x0,Sf,Mf,psi,Ts,Ns,nf);        
 uh=[u u(Ns)]; t=tf*[0:1/Ns:1]/(2*pi); tf=tf/(2*pi);
 figure(i); clf; subplot(211), plot(t,x(1,:)); axis tight
 grid; hold on; ylabel('y'); subplot(212), zohplot(t,uh);
 grid; hold on; plot(t,x(3,:),'r--'); hold off; axis tight
 xlabel('t/(2\pi)'); legend('u','\theta') 
end
	