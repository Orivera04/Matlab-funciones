% Script tvex2.m; Time-Varying EXample of 2nd order LQ optimization;
% dot(x)=v, dot(v)=-t*v-x+u; J=int[0:tf](u^2/2)dt, s=[x v]'; 8/22/02
%
tf=2; s0=[1 0]'; sf=[-1 0]'; name='tvex2_h'; 
[t,y]=tvlqh(name,tf,s0,sf); x=y(:,1); v=y(:,2); u=-y(:,4); 
%
figure(1); clf; subplot(211), plot(t,x,t,v,'r--'); grid
legend('x','v'); subplot(212), plot(t,u); grid; ylabel('u')
xlabel('Time')
