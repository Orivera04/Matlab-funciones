function [c,ceq,th,q,y,v,u]=ip_c2(p,ep,umax)               
% Subroutine for Pb. 9.3.13b;                  4/98, 3/29/02
%
N=(1+length(p))/2; v=[0 p([1:N-1]) 0]; q=[0 p([N:2*N-2]) 0];
tf=p(2*N-1); qb=.5*(q([2:N+1])+q([1:N])); 
vb=.5*(v([2:N+1])+v([1:N])); th(1)=0; y(1)=0; dt=tf/N; 
for i=1:N, th(i+1)=th(i)+dt*qb(i); y(i+1)=y(i)+dt*vb(i); end
qd=(q([2:N+1])-q([1:N]))/dt; vd=(v([2:N+1])-v([1:N]))/dt;
thb=.5*(th(2:N+1)+th(1:N));
for i=1:N, co=cos(thb(i)); s=sin(thb(i));
   u(i)=(1-ep*co^2)*vd(i)-ep*s*(co+qb(i)^2);
   g(i)=(1-ep*co^2)*qd(i)+s+co*(u(i)+ep*s*(qb(i))^2);
   c(i)=abs(u(i))-umax; 
end
ceq=[y(N+1) th(N+1)-pi];

