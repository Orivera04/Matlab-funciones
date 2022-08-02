% Script p5_5_08.m; cart w. inv. pendulum using TDLQH (flg=1) or
% TDLQHR (flg=2); M=cart mass, m=pendulum mass, l=pendulum length,
% u=force on cart, y=cart displ., th=pend. angle; x=[y ydot th thdot]';
% t in sqrt[Ml/(M+m)g]/2*pi, u in (M+m)g, y in l, ep=m/(m+M); 
% psi=Mf*x(N); both FAIL FOR tf > 18;          	          2/95, 7/25/02
%
flg=2; tf=[6 15]; N=[20 50]; ep=.5; x0=[0 0 0 0]'; psi=[1 0 0 0]';
A=[0 1 0 0; 0 0 -ep 0; 0 0 0 1; 0 0 1 0]; B=[0 1 0 -1]'; Sf=zeros(4); 
Mf=eye(4); Qd=zeros(4); Nd=zeros(4,1); Rd=1; nf=3;  
for i=1:2, Ts=tf(i)/N(i); [Ph,Ga]=c2d(A,B,Ts);  
 if flg==1,     [x,u]=tdlqh (Ph,Ga,Qd,Nd,Rd,x0,Sf,Mf,psi,Ts,N(i));
 elseif flg==2, [x,u]=tdlqhr(Ph,Ga,Qd,Nd,Rd,x0,Sf,Mf,psi,Ts,N(i),nf);
 end; t=tf(i)*[0:1/N(i):1]; uh=[u u(N(i))];
 figure(i); clf; subplot(211), plot(t,x(1,:)); grid; ylabel('y')
 subplot(212), zohplot(t,uh,'r--'); grid; hold on; plot(t,x(3,:),'-');
 hold off; xlabel('t'); legend('\theta','u')
end

