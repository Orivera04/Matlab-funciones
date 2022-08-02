% Script p5_5_10.m; cart w. inv. pendulum using TDLQH (flg=1) or TDLQHR
% (flg=2); M=cart mass, m=pend. mass, l=pend. length, u=force on cart, 
% y=cart displ., th=pend. angle; x= [y ydot th thdot]'; t in
% sqrt[Ml/(M+m)g]/2*pi, u in (M+m)g, y in l, ep=m/(m+M); psi=Mf*x(N);
% BOTH FAIL FOR tf>18; 	                                  2/95, 7/25/02
%
flg=1; tf=[6 15]; N=[20 50]; ep=.5; s0=[0 0 0 0]'; psi=[1 0 0 0]';
Sf=zeros(4); A=[0 1 0 0; 0 0 -ep 0; 0 0 0 1; 0 0 1 0]; Rd=1;
B=[0 1 0 -1]'; Mf=eye(4); Qd=zeros(4); Nd=zeros(4,1); nf=5;  
for i=1:2,
  Ts=tf(i)/N(i); [Ph,Ga]=c2d(A,B,Ts); t=tf(i)*[0:1/N(i):1];  
  if flg==1, [s,u]=tdlqh(Ph,Ga,Qd,Nd,Rd,s0,Sf,Mf,psi,Ts,N(i));
  elseif flg==2, [s,u]=tdlqhr(Ph,Ga,Qd,Nd,Rd,s0,Sf,Mf,psi,Ts,N(i),nf);
  end; uh=[u u(N(i))];
  figure(i); clf; subplot(211), plot(t,s(1,:)); grid; ylabel('y')
  subplot(212), zohplot(t,uh,'r--'); grid; hold on; plot(t,s(3,:),'-');
  hold off; xlabel('t'); legend('\theta','u')
end