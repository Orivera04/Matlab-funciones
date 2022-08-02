function [ceq,c]=dtdpt_c(p,yf)                   
% Subroutine for e04_3_2, p4_3_06a; DTDP for min tf to vf=0 & spec. 
% (uf,yf); t in units of uf/a; (u,v) in uf; (x,y) in uf^2/a; 
% s=[u,v,y,x]'=state vector; th=theta=control;      3/97, 3/14/02
%
N=length(p)-1; th=p([1:N]); tf=p(N+1); u(1)=0; v(1)=0; x(1)=0; y(1)=0;
dt=tf/N; 
for i=1:N, co=cos(th(i)); si=sin(th(i));
 u(i+1)=u(i)+dt*co; v(i+1)=v(i)+dt*si;
 y(i+1)=y(i)+dt*v(i)+dt^2*si/2; x(i+1)=x(i)+dt*u(i)+dt^2*co/2;
end
ceq=[]; c=[u(N+1)-1 v(N+1) y(N+1)-yf]';


	
