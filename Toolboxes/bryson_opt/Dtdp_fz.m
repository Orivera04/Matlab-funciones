function [f,u,v,y,x]=dtdp_fz(th,s0,tf,N,gv,yf)	       
% Subroutine for e03_2_2 and p3_1_09a; 11/94, 6/98, 3/13/02 
%
u(1)=s0(1); v(1)=s0(2); y(1)=s0(3); x(1)=s0(4); dt=tf/N; 
for i=1:N, si=sin(th(i)); c=cos(th(i)); 
 u(i+1)=u(i)+dt*c; v(i+1)=v(i)+dt*si-gv*dt;
 y(i+1)=y(i)+dt*v(i)+dt^2*si/2-.5*gv*dt^2; x(i+1)=x(i)+dt*u(i)+dt^2*c/2;
end
f=-u(N+1);

